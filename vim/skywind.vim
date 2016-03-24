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
let g:winManagerWindowLayout = "FileExplorer|TagList"
"let g:winManagerWindowLayout = "FileExplorer|Tagbar"
let g:winManagerWidth=30


let g:Tagbar_title = "[Tagbar]"
let g:tagbar_vertical = 30
" let g:tagbar_left = 1
function! Tagbar_Start()
    exe 'TagbarOpen'
    exe 'q' 
endfunction
 
function! Tagbar_IsValid()
    return 1
endfunction

function! WMResize()
	exec "FirstExplorerWindow"
	exec "vertical resize 30"	
	exec "wincmd l"
endfunc

function! WMFocusEdit(n)
	exec "FirstExplorerWindow"
	exec "wincmd l"
	if a:n > 0
		exec "wincmd l"
	endif
endfunc

function! WMFocusQuickfix()
	exec "FirstExplorerWindow"
	exec "wincmd l"
	exec "wincmd j"
endfunc

function! ToggleDevelop(layout)
	if s:enter == 0
		set showtabline=2
		let s:enter = 1
	endif
	if a:layout == 0
		set nonumber
		exec 'copen 6'
		exec 'wincmd k'
		exec 'wincmd l'
		exec 'WMToggle'
		exec 'wincmd l'
		let s:screenw = &columns
		let s:screenh = &lines
		let s:size = (s:screenw - 32) / 2
		exec 'set number'
		call WMResize()
		if s:size >= 65
			exec 'vs'
			exec 'wincmd h'
			exec 'wincmd h'
			exec 'vertical resize 30'
			exec 'wincmd l'
			exec 'vertical resize ' . s:size
		endif
		"let s:enter = 1
	elseif a:layout == 1
		set nonumber
		exec 'copen'
		exec 'wincmd k'
		exec 'wincmd l'
		exec 'WMToggle'
		exec 'wincmd l'
		exec 'TagbarOpen'
		call WMResize()
		exec 'wincmd l'
		exec 'wincmd l'
		exec 'vertical resize 30'
		exec 'wincmd h'
		set number
		let s:size = (&columns - 62)
		exec 'vertical resize ' . s:size
	endif
endfunc

noremap <F10> :call ToggleDevelop(0)<cr>
inoremap <F10> <ESC>:call ToggleDevelop(0)<cr>

function! SkywindUpdateCTags()
	exec '!ctags -R -f .tags *'
endfunc

noremap <leader>f1 :FirstExplorerWindow<cr>
noremap <leader>f2 :BottomExplorerWindow<cr>
noremap <leader>f3 :call WMFocusEdit(0)<cr>
noremap <leader>f4 :call WMFocusEdit(1)<cr>
noremap <leader>f0 :call WMFocusQuickfix()<cr>
noremap <leader>fm :call ToggleDevelop(0)<cr>
noremap <leader>fn :call ToggleDevelop(1)<cr>
noremap <leader>ft :call SkywindUpdateCTags()<cr>


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




