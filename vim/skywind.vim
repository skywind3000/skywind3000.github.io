" Build system for vim
"
" Maintainer: skywind3000 (at) gmail.com
" Last change: 2016.3.20
"
function! SaveFile()
	exec "w"
endfunc

function! ExecuteFile()
	exec '!"%:p"'
endfunc

function! ExecuteMain()
	exec '!"%:p:h/%:t:r"'
endfunc

function! ExecutePython()
	exec "update"
	exec '!python "%"'
endfunc

function! ExecuteEmake()
	exec '!emake -e "%"'
endfunc

function! BuildEmake(filename, ininame, quickfix)
	if (!a:quickfix) || (!has("quickfix"))
		if a:ininame == ''
			exec '!emake "' . a:filename . '"'
		else
			exec '!emake "--ini=' . a:ininame . '" "' . a:filename . '"'
		endif
	else
		if a:ininame == ''
			set makeprg=emake\ \"%\"
			exec "make"
		else
			exec 'set makeprg=emake\ \"--ini=' . a:ininame . '\"\ \"%\"'
			exec "make"
		endif
	endif
endfunc

function! RunClever()
	let l:ext = expand("%:e")
	let l:cpp = ['c', 'cpp', 'cc', 'm', 'mm', 'cxx']
	let l:pys = ['py', 'pyw', 'pyc', 'pyo']
	let l:emk = ['mak', 'emake']
	if index(l:cpp, l:ext) >= 0
		exec "call ExecuteMain()"
	elseif index(l:pys, l:ext) >= 0
		exec '!python "%"'
	elseif index(l:emk, l:ext) >= 0
		exec "call ExecuteEmake()"
	elseif &filetype == "vim"
		exec 'source %'
	elseif l:ext  == "js"
		exec '!node "%"'
	elseif l:ext == 'sh'
		exec '!sh "%"'
	elseif l:ext == 'lua'
		exec '!lua "%"'
	elseif l:ext == 'pl'
		exec '!perl "%"'
	elseif l:ext == 'rb'
		exec '!ruby "%"'
	elseif l:ext == 'php'
		exec '!php "%"'
	else
		exec "call ExecuteFile()"
	endif
endfunc

let g:skywind_flags = ''

function! CompileGcc()
	exec 'w'
	let l:compileflag = g:skywind_flags
	let l:extname = expand("%:e")
	if index(['cpp', 'cc', 'cxx', 'mm'])
		let l:compileflag .= ' -lstdc++'
	endif
	if !has("quickfix")
		exec '!gcc -Wall "%" -o "%<" ' . l:compileflag
	else
		exec 'set makeprg=emake\ \"--ini=' . a:ininame . '\"\ \"%\"'
		let l:cflags = substitute(l:compileflag, ' ', '\\ ', 'g')
		let l:cflags = substitute(l:cflags, '"', '\\"', 'g')
		exec 'set makeprg=gcc\ -Wall\ \"%\"\ -o\ \"%<\"\ ' . l:cflags
		exec 'make'
	endif
endfunc

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
		exec '!"' . a:command . '"'
	else
		exec "set makeprg=" . a:command
		exec "make"
	endif
endfunc

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
		let s:winopen = 2
	else
		exec "cclose"
		let s:winopen = 1
	endif
endfunc

set errorformat=%f:%l:%m

noremap <F5> :call RunClever()<CR>
inoremap <F5> <C-o>:call RunClever()<CR>

noremap <F6> :call ExecuteFile()<CR>
inoremap <F6> <C-o>:call ExecuteFile()<CR>

noremap <F7> :call BuildEmake(expand("%"), "", 1)<CR>
inoremap <F7> <C-o>:call BuildEmake(expand("%"), "", 1)<CR>

noremap <F8> :call CompileGcc()<CR>
inoremap <F8> <C-o>:call CompileGcc()<CR>

noremap <F9> :call ExecuteEmake()<CR>
inoremap <F9> <C-o>:call ExecuteEmake()<CR>

noremap <silent><F10> :call ToggleQuickFix()<cr>
inoremap <silent><F10> <C-o>:call ToggleQuickFix()<cr>

noremap <silent><leader>cp :cp<cr>
noremap <silent><leader>cn :cn<cr>
noremap <silent><leader>co :copen 5<cr>
noremap <silent><leader>cc :cclose<cr>

for s:i in range(10)
	let s:name = '<F' . s:i . '>'
	if s:i == 0
		let s:name = '<F10>'
	endif
	let s:cm1 = 'noremap <silent><leader>' . s:name . ' :call '
	let s:cm2 = 'noremap <silent><tab>' . s:name . ' :call '
	let s:run = expand('~/.vim/skywind.') . s:i
	let s:cm1 = s:cm1 . 'ExecuteCommand("' . s:run . '", 0)<cr>'
	let s:cm2 = s:cm2 . 'ExecuteCommand("' . s:run . '", 1)<cr>'
	exec s:cm1
	exec s:cm2
endfor





