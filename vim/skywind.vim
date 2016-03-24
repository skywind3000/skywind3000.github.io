let &tags .= ',.tags,' . expand('~/.vim/tags/standard.tags')

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
			return
		endif
	endfor
	echo 'switch failed, can not find another part of c/c++ source'
endfunc

noremap <silent><leader>b :call SwitchHeader()<cr>
noremap <tab>e :BD<cr>

let s:enter = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_list_hide= '.*\.swp$,.*\.pyc,*\.o,*\.bak,\.git,\.svn'

let g:bufExplorerWidth=30
let g:winManagerWindowLayout = "TagList|FileExplorer"
let g:winManagerWidth=30

let s:screenw = &columns
let s:screenh = &lines

function! ToggleDevelop()
	if s:enter == 0
		set showtabline=2
		let s:enter = 1
	endif
	if s:enter == 1
		exec 'copen 6'
		exec 'wincmd k'
		exec 'wincmd l'
		exec 'WMToggle'
		exec 'wincmd l'
		let s:screenw = &columns
		let s:screenh = &lines
		let s:size = (s:screenw - 32) / 2
		if s:size >= 65
			exec 'set number'
			exec 'vs'
			exec 'wincmd h'
			exec 'wincmd h'
			exec 'vertical resize 30'
			exec 'wincmd l'
			exec 'vertical resize ' . s:size
		endif
		"let s:enter = 1
	else
		
	endif
endfunc

noremap <F10> :call ToggleDevelop()<cr>
inoremap <F10> <ESC>:call ToggleDevelop()<cr>

noremap ¡ :tabn1<cr>
noremap ™ :tabn2<cr>
noremap £ :tabn3<cr>
noremap ¢ :tabn4<cr>
noremap ∞ :tabn5<cr>
noremap § :tabn6<cr>
inoremap ¡ <esc>:tabn1<cr>
inoremap ™ <esc>:tabn2<cr>
inoremap £ <esc>:tabn3<cr>
inoremap ¢ <esc>:tabn4<cr>
inoremap ∞ <esc>:tabn5<cr>
inoremap § <esc>:tabn6<cr>




