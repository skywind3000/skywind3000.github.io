if(has("win32") || has("win64") || has("win95") || has("win16"))
	let g:iswindows = 1
else
	let g:iswindows = 0
endif

func! SaveFile()
	exec "w"
endfunc

func! ExecuteFile()
	exec "update"
	exec "!./%"
endfunc

func! ExecuteMain()
	exec "update"
	exec "!./%<"
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
	let compileflag .= " -lstdc++ -lpthread -lrt "
	exec "!gcc -Wall % -o %< ".compileflag
endfunc

func! BuildEmake()
	exec "update"
	exec "!emake %"
endfunc


map <F2> :call SaveFile()<CR>
imap <F2> <ESC>:call SaveFile()<CR>
vmap <F2> <ESC>:call SaveFile()<CR>


map <F4> :call ExecuteFile()<CR>
imap <F4> <ESC>:call ExecuteFile()<CR>
vmap <F4> <ESC>:call ExecuteFile()<CR>

map <F5> :call RunClever()<CR>
imap <F5> <ESC>:call RunClever()<CR>
vmap <F5> <ESC>:call RunClever()<CR>

map <F8> :call CompileGcc()<CR>
imap <F8> <ESC>:call CompileGcc()<CR>
vmap <F8> <ESC>:call CompileGcc()<CR>

map <F9> :call BuildEmake()<CR>
imap <F9> <ESC>:call BuildEmake()<CR>
vmap <F9> <ESC>:call BuildEmake()<CR>

map <F10> :call ExecuteEmake()<CR>
imap <F10> <ESC>:call ExecuteEmake()<CR>
vmap <F10> <ESC>:call ExecuteEmake()<CR>

