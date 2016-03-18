func! SaveFile()
	exec "w"
endfunc

func! ExecuteFile()
	exec "update"
	exec "!%:p"
endfunc

func! ExecuteMain()
	exec "update"
	exec "!%:p:h/%:t:r"
endfunc

func! ExecutePython()
	exec "update"
	exec "!python %"
endfunc

func! ExecuteEmake()
	exec "update"
	exec "!emake -e %"
endfunc

func! RunClever()
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
	else
		exec "call ExecuteFile()"
	endif
endfunc

func! CompileGcc()
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

func! BuildEmake()
	exec "update"
	exec "!emake %"
endfunc

let s:winopen = 0

func! ToggleQuickFix()
	if s:winopen
		exec "cclose"
		let s:winopen = 0
	else
		exec "copen 5"
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


