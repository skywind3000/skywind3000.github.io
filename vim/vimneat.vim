set nocompatible
syntax enable
syntax on

set shiftwidth=4
set tabstop=4
set cindent
set autoindent
set fileencodings=utf-8,gb2312,gbk,gb18030,big5
set fenc=utf-8
set enc=utf-8
set showtabline=1
set mouse=c
set winaltkeys=no
set hidden
set nobackup
set nowritebackup
set nowrap
set wildignore=*.swp,*.bak,*.pyc,*.obj,*.o,*.class
set backspace=eol,start,indent
set cmdheight=1
set ruler
set nopaste


" map CTRL_HJKL to move cursor in all mode
noremap <C-h> h
noremap <C-j> j
noremap <C-k> k
noremap <C-l> l
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>l

" use hotkey to change buffer
noremap <silent><F2> :bp<CR>
noremap <silent><F3> :bn<CR>
inoremap <silent><F2> <C-o>:bp<CR>
inoremap <silent><F3> <C-o>:bn<CR>
noremap <silent><tab>n :bn<cr>
noremap <silent><tab>p :bp<cr>
noremap <silent><tab>m :bm<cr>
noremap <silent><tab>v :vs<cr>
noremap <silent><tab>c :nohl<cr>
noremap <silent><S-tab> :bn<cr>

" miscs
set scrolloff=3
set laststatus=1
set showmatch
set display=lastline
" colorscheme evening
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)

set listchars=tab:\|\ ,trail:.,extends:>,precedes:<
set matchtime=3

" leader definition
noremap <silent><leader>w :w<cr>
noremap <silent><leader>q :q<cr>
noremap <silent><leader>c :close<cr>
noremap <silent><leader>d :bp\|bd #<CR>

" window management
noremap <leader>h <c-w>h
noremap <leader>j <c-w>j
noremap <leader>k <c-w>k
noremap <leader>l <c-w>l
noremap <tab>h <c-w>h
noremap <tab>j <c-w>j
noremap <tab>k <c-w>k
noremap <tab>l <c-w>l
noremap <tab>w <c-w>w
noremap <F4> <c-w>w
inoremap <F4> <C-o><c-w>w

" set number
let s:need_number = 0

function! ToggleNumberView()
	if s:need_number == 0
		set number
		let s:need_number = 1
	else
		set nonumber
		let s:need_number = 0
	endif
endfunc

noremap <silent><leader>n :call ToggleNumberView()<cr>

" ctrl-enter to insert a empty line below, shift-enter to insert above
noremap <tab>o o<ESC>
noremap <tab>O O<ESC>

" delete buffer keep window
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Command ':BufClose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:BufClose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :BufClose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? BufClose call s:BufClose('<bang>', '<args>')
nnoremap <silent><leader>e :BufClose<CR>



