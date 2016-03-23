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
noremap <leader>w :w<cr>
noremap <leader>q :q<cr>
noremap <leader>c :close<cr>

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

