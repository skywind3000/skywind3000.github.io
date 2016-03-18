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


noremap <F2> :call SaveFile()<CR>
inoremap <F2> <ESC>:call SaveFile()<CR>

noremap <F4> :call ExecuteFile()<CR>
inoremap <F4> <ESC>:call ExecuteFile()<CR>

noremap <F5> :call RunClever()<CR>
inoremap <F5> <ESC>:call RunClever()<CR>

noremap <F8> :call CompileGcc()<CR>
inoremap <F8> <ESC>:call CompileGcc()<CR>

noremap <F9> :call BuildEmake()<CR>
inoremap <F9> <ESC>:call BuildEmake()<CR>

map <F10> :call ExecuteEmake()<CR>
imap <F10> <ESC>:call ExecuteEmake()<CR>

set makeprg=emake\ \"%\"
set errorformat=%f:%l:%m

noremap <F7> :make<CR>
inoremap <F7> <C-o>:make<CR>



