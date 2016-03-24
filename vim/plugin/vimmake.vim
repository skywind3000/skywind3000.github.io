" vimmake.vim - Enhenced Customize Make system for vim
"
" Maintainer: skywind3000 (at) gmail.com
" Last change: 2016.3.20
"
" Execute customize tools directly:
"     <leader><F1-F9> execute ~/.vim/vimmake.1 - ~/.vim/vimmake.9
"
" Execute customize tools in quickfix mode:
"     <tab><F1-F9> execute ~/.vim/vimmake.1 - ~/.vim/vimmake.9
"
" Environment variables are set to below before executing:
"     $VIM_FILEPATH  - File name of current buffer with full path
"     $VIM_FILENAME  - File name of current buffer without path
"     $VIM_FILEDIR   - Full path of current buffer without the file name
"     $VIM_FILEEXT   - File extension of current buffer
"     $VIM_FILENOEXT - File name of current buffer without path and extension
"     $VIM_CWD       - Current directory
"     $VIM_RELDIR    - File path relativize to current directory
"     $VIM_RELNAME   - File name relativize to current directory 
"
"
" Execute customize tools: ~/.vim/vimmake.{name} directly:
"     :Vimmake {name}
"
" Execute customize tools: ~/.vim/vimmake.{name} in quickfix mode:
"     :Vimmake! {name}
"
" Support:
"     <F5>  Run current file by detecting file type
"     <F6>  Execute current file directly
"     <F7>  Build with emake
"     <F8>  Execute emake project
"     <F9>  Compile with gcc/clang
"     <F10> Toggle quickfix window
"     <F11> Previous quickfix error
"     <F12> Next quickfix error
" 
" Emake can be installed to /usr/local/bin to build C/C++ by: 
"     $ wget https://skywind3000.github.io/emake/emake.py
"     $ sudo python emake.py -i
"
"

" Execute current filename directly
function! ExecuteFile()
	exec '!' . shellescape(expand("%:p"))
endfunc

" Execute current filename without extname
function! ExecuteMain()
	exec '!' . shellescape(expand("%:p:r"))
endfunc

" Execute executable of current emake project
function! ExecuteEmake()
	exec '!emake -e ' . shellescape(expand("%"))
endfunc

" backup local makeprg and errorformat
function! s:MakeSave()
	let s:make_save = &makeprg
	let s:match_save = &errorformat
endfunc

" restore local makeprg and errorformat
function! s:MakeRestore()
	exec 'setlocal makeprg=' . fnameescape(s:make_save)
	exec 'setlocal errorformat=' . fnameescape(s:match_save)
endfunc



" Execute command in both quickfix and non-quickfix mode
function! ExecuteCommand(command, quickfix)
	let $VIM_FILEPATH = expand("%:p")
	let $VIM_FILENAME = expand("%:t")
	let $VIM_FILEDIR = expand("%:p:h")
	let $VIM_FILENOEXT = expand("%:t:r")
	let $VIM_FILEEXT = "." . expand("%:e")
	let $VIM_CWD = expand("%:p:h:h")
	let $VIM_RELDIR = expand("%:h")
	let $VIM_RELNAME = expand("%:p:.")
	if (!a:quickfix) || (!has("quickfix"))
		exec '!' . shellescape(a:command)
	else
		call s:MakeSave()
		setlocal errorformat=%f:%l:%m
		exec "setlocal makeprg=" . fnameescape(a:command)
		exec "make!"
		call s:MakeRestore()
	endif
endfunc


" global CFLAGS to be passed to gcc
let g:vimmake_cflags = ''
let g:vimmake_save = 0

" Execute ~/.vim/vimmake.{command} 
function! s:VimMake(bang, command)
	if g:vimmake_save
		exec "w"
	endif
	let l:fullname = "~/.vim/vimmake." . a:command
	let l:fullname = expand(l:fullname)
	if a:bang == ''
		call ExecuteCommand(l:fullname, 0)
	else
		call ExecuteCommand(l:fullname, 1)
	endif
endfunc

" command definition
command! -bang -nargs=1 Vimmake call s:VimMake('<bang>', <f-args>)

" build via gcc
function! CompileGcc()
	if g:vimmake_save
		exec "w"
	endif
	let l:compileflag = g:vimmake_cflags
	let l:extname = expand("%:e")
	if index(['cpp', 'cc', 'cxx', 'mm'], l:extname)
		let l:compileflag .= ' -lstdc++'
	endif
	if !has("quickfix")
		exec '!gcc -Wall "%" -o "%<" ' . l:compileflag
	else
		call s:MakeSave()
		let l:cflags = substitute(l:compileflag, ' ', '\\ ', 'g')
		let l:cflags = substitute(l:cflags, '"', '\\"', 'g')
		exec 'setlocal makeprg=gcc\ -Wall\ \"%\"\ -o\ \"%<\"\ ' . l:cflags
		setlocal errorformat=%f:%l:%m
		exec 'make!'
		call s:MakeRestore()
	endif
endfunc


" build via emake (http://skywind3000.github.io/emake/emake.py)
function! BuildEmake(filename, ininame, quickfix)
	if g:vimmake_save
		exec "w"
	endif
	if (!a:quickfix) || (!has("quickfix"))
		if a:ininame == ''
			exec '!emake ' . shellescape(a:filename) . ''
		else
			exec '!emake "--ini=' . a:ininame . '" ' . shellescape(a:filename) . ''
		endif
	else
		call s:MakeSave()
		setlocal errorformat=%f:%l:%m
		let l:fname = '\"' . fnameescape(a:filename) . '\"'
		if a:ininame == ''
			exec 'setlocal makeprg=emake\ ' . l:fname 
			exec "make!"
		else
			exec 'setlocal makeprg=emake\ \"--ini=' . a:ininame . '\"\ ' . l:fname
			exec "make!"
		endif
		call s:MakeRestore()
	endif
endfunc


" run current file by detecting file extname
function! RunClever()
	if g:vimmake_save
		exec "w"
	endif
	let l:ext = expand("%:e")
	if index(['c', 'cpp', 'cc', 'm', 'mm', 'cxx'], l:ext) >= 0
		exec "call ExecuteMain()"
	elseif index(['py', 'pyw', 'pyc', 'pyo'], l:ext) >= 0
		exec '!python ' . fnameescape(expand("%"))
	elseif index(['mak', 'emake'], l:ext) >= 0
		exec "call ExecuteEmake()"
	elseif &filetype == "vim"
		exec 'source ' . fnameescape(expand("%"))
	elseif l:ext  == "js"
		exec '!node ' . shellescape(expand("%"))
	elseif l:ext == 'sh'
		exec '!sh ' . shellescape(expand("%"))
	elseif l:ext == 'lua'
		exec '!lua ' . shellescape(expand("%"))
	elseif l:ext == 'pl'
		exec '!perl ' . shellescape(expand("%"))
	elseif l:ext == 'rb'
		exec '!ruby ' . shellescape(expand("%"))
	elseif l:ext == 'php'
		exec '!php ' . shellescape(expand("%"))
	else
		call ExecuteFile()
	endif
endfunc


" global settings
let s:winopen = 0
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)
set laststatus=1

function! ToggleQuickFix()
	if s:winopen == 0
		exec "copen 5"
		exec "wincmd k"
		set number
		set laststatus=2
		let s:winopen = 2
	elsei s:winopen == 1
		exec "copen 5"
		exec "wincmd k"
		let s:winopen = 2
	else
		exec "cclose"
		let s:winopen = 1
	endif
endfunc


noremap <silent><F5> :call RunClever()<CR>
inoremap <silent><F5> <C-o>:call RunClever()<CR>

noremap <silent><F6> :call ExecuteFile()<CR>
inoremap <silent><F6> <C-o>:call ExecuteFile()<CR>

noremap <silent><F7> :call BuildEmake(expand("%"), "", 1)<CR>
inoremap <silent><F7> <C-o>:call BuildEmake(expand("%"), "", 1)<CR>

noremap <silent><F8> :call ExecuteEmake()<CR>
inoremap <silent><F8> <C-o>:call ExecuteEmake()<CR>

noremap <silent><F9> :call CompileGcc()<CR>
inoremap <silent><F9> <C-o>:call CompileGcc()<CR>

noremap <silent><F10> :call ToggleQuickFix()<cr>
inoremap <silent><F10> <C-o>:call ToggleQuickFix()<cr>

noremap <silent><F11> :cp<cr>
noremap <silent><F12> :cn<cr>
inoremap <silent><F11> <C-o>:cp<cr>
inoremap <silent><F12> <C-o>:cn<cr>

noremap <silent><leader>cp :cp<cr>
noremap <silent><leader>cn :cn<cr>
noremap <silent><leader>co :copen 5<cr>
noremap <silent><leader>cc :cclose<cr>

for s:i in range(10)
	let s:name = '<F' . s:i . '>'
	if s:i == 0
		let s:name = '<F10>'
	endif
	exec 'noremap <silent><leader>' . s:name . ' :Vimmake ' . s:i . '<cr>'
	exec 'noremap <silent><tab>' . s:name . ' :Vimmake! ' . s:i . '<cr>'
endfor


" grep code
let g:vimmake_grepinc = ['c', 'cpp', 'cc', 'h', 'hpp', 'hh', 'm', 'mm', 'py', 'js']

function! s:GrepCode(text)
	let l:inc = ''
	for l:item in g:vimmake_grepinc
		let l:inc .= " --include \\*." . l:item
	endfor
	exec 'grep -R ' . shellescape(a:text) . l:inc. ' *'
endfunc


command! -nargs=1 GrepCode call s:GrepCode(<f-args>)



