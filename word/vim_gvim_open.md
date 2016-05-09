"=========== Meta ============
"StrID : 1708
"Title : GVim 中更好的运行程序
"Slug  : 
"Cats  : 随笔
"Tags  : Vim
"=============================
"EditType   : post
"EditFormat : Markdown
"TextAttach : vimpress_57304957_mkd.txt
"========== Content ==========
GVim（Windows）下面使用!运行程序是非常恶心的事情，比如调用python运行当前脚本：

```text
:!python %
```

你会发现，整个VIM界面被冻结了，然后弹出cmd窗口，退出cmd后，还要返回GVim中按任意键才能编辑状态。

比如你正在调试一个程序，这个程序运行起来不是一分钟能出结果的时候，你想边对照输出结果，边在 GVim 里面查看和修改你的代码，你就会发现傻逼了。正确的做法是：

```text
:silent !start cmd /c python % & pause
```

这时你会发现优雅的调用了 python 来跑当前程序，并且GVIM不会被挂起，照样可以编辑，当程序结束的时候，CMD窗口还会pause等待你按任意键一下，这就比较清爽了，你可以把这条命令map到你常用的快捷键上，和 EditPlus里面一样一键运行之。

我写了个函数来做这个事情，稍加修改即可使用：

<!--more-->

```text
" run current file by detecting file extname
function! Vimmake_RunClever()
	silent call s:CheckSave()
	if bufname('%') == '' | return | endif
	let l:ext = expand("%:e")
	if index(['c', 'cpp', 'cc', 'm', 'mm', 'cxx', 'h', 'hh', 'hpp'], l:ext) >= 0
		exec "call Vimmake_ExeMain()"
	elseif index(['mak', 'emake'], l:ext) >= 0
		exec "call Vimmake_ExeEmake()"
	elseif &filetype == "vim"
		exec 'source ' . fnameescape(expand("%"))
	elseif has('gui_running') && (has('win32') || has('win64') || has('win16'))
		call s:CwdInit()
		if index(['py', 'pyw', 'pyc', 'pyo'], l:ext) >= 0
			silent exec '!start cmd /C python ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext  == "js"
			silent exec '!start cmd /C node ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'sh'
			silent exec '!start cmd /C sh ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'lua'
			silent exec '!start cmd /C lua ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'pl'
			silent exec '!start cmd /C perl ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'rb'
			silent exec '!start cmd /C ruby ' . shellescape(expand("%")) . ' & pause'
		elseif l:ext == 'php'
			silent exec '!start cmd /C php ' . shellescape(expand("%")) . ' & pause'
		elseif index(['osa', 'scpt', 'applescript'], l:ext) >= 0
			silent exec '!start cmd /C osascript '. shellescape(expand('%')) . ' & pause'
		else
			call Vimmake_ExeFile()
		endif
		call s:CwdRestore()
	else
		call s:CwdInit()
		if index(['py', 'pyw', 'pyc', 'pyo'], l:ext) >= 0
			exec '!python ' . shellescape(expand("%"))
		elseif l:ext  == "js"
			exec '!node ' . shellescape(expand("%"))
		elseif l:ext == 'sh'
			exec '!sh ' . shellescape(expand("%"))
		elseif l:ext == 'lua'
			exec '!lua ' . shellescape(expand("%"))
		elseif l:ext == 'pl'
			exec '!perl ' . shellescape(expand("%"))
		elseif l:ext == 'rb'
			exec '!ruby ' . shellescape(expand("%"))
		elseif l:ext == 'php'
			exec '!php ' . shellescape(expand("%"))
		elseif index(['osa', 'scpt', 'applescript'], l:ext) >= 0
			exec '!osascript '. shellescape(expand('%'))
		else
			call Vimmake_ExeFile()
		endif
		call s:CwdRestore()
	endif
endfunc



```

你可以把该函数绑定到 F5上，自动判断是否运行在GVIM下面，并用正确的方式执行当前代码，函数中几处外部调用用来判断文件是否需要保存，以及是否需要切换到文件当前目录的地方，你稍微修改两下既可。

![](http://skywind3000.github.io/word/images/donation.png)


