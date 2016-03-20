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

" use hotkey to save file
noremap <F2> :w<CR>
inoremap <F2> <C-o>:w<CR>

" use hotkey to change buffer
noremap <F3> :bn<CR>
inoremap <F3> <C-o>:bn<CR>
noremap <leader>bn :bn<cr>
noremap <leader>bp :bp<cr>
noremap <leader>bf :bf<cr>
noremap <leader>bl :ls<cr>
noremap <silent><tab>n :bn<cr>
noremap <silent><tab>p :bp<cr>
noremap <tab>h <c-w>h
noremap <tab>j <c-w>j
noremap <tab>k <c-w>k
noremap <tab>l <c-w>l
noremap <tab>w <c-w>w
noremap <silent><tab>v :vs<cr>
noremap <silent><tab>c :nohl<cr>

" miscs
" set scrolloff=3
set scrolloff=3
set laststatus=1
set showmatch
set display=lastline
" colorscheme evening
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)

set listchars=tab:\|\ ,trail:.,extends:>,precedes:<
set matchtime=5

noremap <leader>s :w<cr>
noremap <leader>q :q<cr>
noremap <leader>c :close<cr>

noremap <leader>h <c-w>h
noremap <leader>j <c-w>j
noremap <leader>k <c-w>k
noremap <leader>l <c-w>l
noremap <leader>w <c-w>w

nnoremap <silent><C-a> ggvG$
vnoremap <C-c> "+y


