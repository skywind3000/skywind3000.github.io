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

if os =~ 'mac'
	imap ˙ <Left>
	imap ∆ <Down>
	imap ˚ <Up>
	imap ¬ <Right>
	map ˙ <Left>
	map ∆ <Down>
	map ˚ <Up>
	map ¬ <Right>
	vmap ˙ <Left>
	vmap ∆ <Down>
	vmap ˚ <Up>
	vmap ¬ <Right>
	imap ≈ <Delete>
	map ≈ <Delete>
	vmap ≈ <Delete>
	map ≤ <ESC>:tabp<CR>
	map ≥ <ESC>:tabn<CR>
	imap ≤ <ESC>:tabp<CR>
	imap ≥ <ESC>:tabn<CR>
else
	imap <A-h> <Left>
	imap <A-j> <Down>
	imap <A-k> <Up>
	imap <A-l> <Right>
	map <A-h> <Left>
	map <A-j> <Down>
	map <A-k> <Up>
	map <A-l> <Right>
	vmap <A-h> <Left>
	vmap <A-j> <Down>
	vmap <A-k> <Up>
	vmap <A-l> <Right>
	map <A-x> <Delete>
	imap <A-x> <Delete>
	map <A-,> <ESC>:tabp<CR>
	map <A-.> <ESC>:tabn<CR>
	imap <A-,> <ESC>:tabp<CR>
	imap <A-.> <ESC>:tabn<CR>
endif


