let &tags .= ',.tags,' . expand('~/.vim/tags/standard.tags')

noremap <silent><S-tab> :bn<cr>

function! SwitchHeader()
	let l:main = expand('%:p:r')
	let l:fext = expand('%:e')
	if index(['c', 'cpp', 'm', 'mm', 'cc'], l:fext) >= 0
		let l:altnames = ['h', 'hpp', 'hh']
	elseif index(['h', 'hh', 'hpp'], l:fext) >= 0
		let l:altnames = ['c', 'cpp', 'cc', 'm', 'mm']
	else
		echo 'switch failed, not a c/c++ source'
		return
	endif
	for l:next in l:altnames
		let l:newname = l:main . '.' . l:next
		if filereadable(l:newname)
			exec 'e ' . fnameescape(l:newname)
		endif
	endfor
endfunc

noremap <silent><leader>b :call SwitchHeader()<cr>
noremap <tab>e :BD<cr>

let s:enter = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

function! ToggleDevelop()
	if s:enter == 0
		let s:enter = 1
		set showtabline=2
		exec 'set number'
		exec 'copen 6'
		exec 'wincmd k'
		exec 'Sex!'
		exec 'wincmd l'
		exec 'vs'
	else
		
	endif
endfunc

noremap <F10> :call ToggleDevelop()<cr>
inoremap <F10> <ESC>:call ToggleDevelop()<cr>




