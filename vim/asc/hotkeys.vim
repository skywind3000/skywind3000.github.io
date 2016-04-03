
for s:index in range(10)
	let s:key = '' . s:index
	if s:index == 10 | let s:key = '0' | endif
	exec 'noremap <space>'.s:key.' :Vimmake ' . s:key . '<cr>'
	exec 'noremap <tab>'.s:key.' :Vimmake! ' . s:key . '<cr>'
endfor

noremap <space>sc :!svn co -m ""<cr>
noremap <space>su :!svn up<cr>
noremap <space>st :!svn st<cr>



