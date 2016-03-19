function! SaveFile()
	exec "w"
endfunc

function! ExecuteFile()
	exec "update"
	exec "!%:p"
endfunc

function! ExecuteMain()
	exec "update"
	exec "!%:p:h/%:t:r"
endfunc

function! ExecutePython()
	exec "update"
	exec "!python %"
endfunc

function! ExecuteEmake()
	exec "update"
	exec "!emake -e %"
endfunc

function! RunClever()
	if &filetype == "cpp"
		exec "call ExecuteMain()"
	elseif &filetype == "c"
		exec "call ExecuteMain()"
	elseif &filetype == "cc"
		exec "call ExecuteMain()"
	elseif &filetype == "cpp"
		exec "call ExecuteMain()"
	elseif &filetype == "py"
		exec "call ExecutePython()"
	elseif &filetype == "python"
		exec "call ExecutePython()"
	elseif &filetype == "mak"
		exec "call ExecuteEmake()"
	elseif &filetype == "emake"
		exec "call ExecuteEmake()"
	elseif &filetype == "vim"
		exec "source %"
	elseif &filetype == "javascript"
		exec "!node %"
	else
		exec "call ExecuteFile()"
	endif
endfunc

function! CompileGcc()
	exec "update"
	let compileflag=" "
	if search("mpi\.h") != 0
		let compilecmd = "!mpicc "
	endif
	if search("glut\.h") != 0
		let compileflag .= " -lglut -lGLU -lGL "
	endif
	if search("cv\.h") != 0
		let compileflag .= " -lcv -lhighgui -lcvaux "
	endif
	if search("omp\.h") != 0
		let compileflag .= " -fopenmp "
	endif
	if search("math\.h") != 0
		let compileflag .= " -lm "
	endif
	let compileflag .= " -lstdc++ -lpthread "
	exec "!gcc -Wall % -o %< ".compileflag
endfunc

function! BuildEmake()
	exec "update"
	exec "!emake %"
endfunc

function! ExecuteCommand(command)
	let $VIM_FILEPATH = expand("%:p")
	let $VIM_FILENAME = expand("%:t")
	let $VIM_FILEDIR = expand("%:p:h")
	let $VIM_FILENOEXT = expand("%:t:r")
	let $VIM_FILEEXT = "." . expand("%:e")
	let $VIM_CWD = expand("%:p:h:h")
	let $VIM_RELDIR = expand("%:h")
	let $VIM_RELNAME = expand("%:p:.")
	exec "!" . a:command
endfunc

let s:winopen = 0
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)
set laststatus=1

function! ToggleQuickFix()
	if s:winopen == 0
		exec "copen 5"
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

set makeprg=emake\ \"%\"
set errorformat=%f:%l:%m

noremap <F5> :call RunClever()<CR>
inoremap <F5> <C-o>:call RunClever()<CR>

noremap <F6> :call ExecuteFile()<CR>
inoremap <F6> <C-o>:call ExecuteFile()<CR>

noremap <F7> :make<CR>
inoremap <F7> <C-o>:make<CR>

noremap <F8> :call CompileGcc()<CR>
inoremap <F8> <C-o>:call CompileGcc()<CR>

noremap <F9> :call ExecuteEmake()<CR>
inoremap <F9> <C-o>:call ExecuteEmake()<CR>

noremap <F10> :call ToggleQuickFix()<cr>
inoremap <F10> <C-o>:call ToggleQuickFix()<cr>

noremap <leader>cp :cp<cr>
noremap <leader>cn :cn<cr>
noremap <leader>co :copen 5<cr>
noremap <leader>cc :cclose<cr>

noremap <leader><F1> :call ExecuteCommand("~/.vim/skywind.1")<cr>
noremap <leader><F2> :call ExecuteCommand("~/.vim/skywind.2")<cr>
noremap <leader><F3> :call ExecuteCommand("~/.vim/skywind.3")<cr>
noremap <leader><F4> :call ExecuteCommand("~/.vim/skywind.4")<cr>
noremap <leader><F5> :call ExecuteCommand("~/.vim/skywind.5")<cr>
noremap <leader><F6> :call ExecuteCommand("~/.vim/skywind.6")<cr>
noremap <leader><F7> :call ExecuteCommand("~/.vim/skywind.7")<cr>
noremap <leader><F8> :call ExecuteCommand("~/.vim/skywind.8")<cr>
noremap <leader><F9> :call ExecuteCommand("~/.vim/skywind.9")<cr>




