set shiftwidth=4
set tabstop=4
set autoindent
set fileencodings=utf-8,gb2312,gbk,gb18030,big5
set fenc=utf-8
set enc=utf-8
set showtabline=1
set mouse=c
set winaltkeys=no

set nobackup
set nowritebackup

function! GetRunningOS()
  if has("win32")
    return "win"
  endif
  if has("unix")
    if system('uname')=~'Darwin'
      return "mac"
    else
      return "linux"
    endif
  endif
endfunction

let os=GetRunningOS()

map ˙ <Left>
map ∆ <Down>
map ˚ <Up>
map ¬ <Right>
map ˙ <Left>
imap ∆ <Down>
imap ˚ <Up>
imap ¬ <Right>
imap ≈ <Delete>

map ≈ <Delete>
vmap ≈ <Delete>


map ≤ <ESC>:tabp<CR>
map ≥ <ESC>:tabn<CR>
imap ≤ <ESC>:tabp<CR>
imap ≥ <ESC>:tabn<CR>

imap <A-h> <Left>
imap <A-j> <Down>
imap <A-k> <Up>
imap <A-l> <Right>
map <A-h> <Left>
map <A-j> <Down>
map <A-k> <Up>
map <A-l> <Right>
map <A-x> <Delete>
imap <A-x> <Delete>

map ¡ <ESC>:tabn1<CR>
imap ¡ <ESC>:tabn1<CR>
map ™ <ESC>:tabn2<CR>
imap ™ <ESC>:tabn2<CR>
map £ <ESC>:tabn3<CR>
imap £ <ESC>:tabn3<CR>
map ¢ <ESC>:tabn4<CR>
imap ¢ <ESC>:tabn4<CR>
map ∞ <ESC>:tabn5<CR>
imap ∞ <ESC>:tabn5<CR>
map § <ESC>:tabn6<CR>
imap § <ESC>:tabn6<CR>
map ¶ <ESC>:tabn7<CR>
imap ¶ <ESC>:tabn7<CR>
map • <ESC>:tabn8<CR>
nmap • <ESC>:tabn8<CR>
imap • <ESC>:tabn8<CR>
map ª <ESC>:tabn9<CR>
imap ª <ESC>:tabn9<CR>
map º <ESC>:tabn10<CR>
imap º <ESC>:tabn10<CR>

map <A-8> :tabn8<CR>
imap <A-8> <ESC>:tabn8<CR>


nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
imap <C-H> <ESC><C-W>h
imap <C-J> <ESC><C-W>j
imap <C-K> <ESC><C-W>k
imap <C-L> <ESC><C-W>L



