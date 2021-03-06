---
uuid: 2420
title: 提高效率从编写 init.sh 开始
status: publish
categories: 未分类
tags: 命令行
---

有部分人不太愿意定制自己的终端配置，因为：“服务器太多，怎么可能每台都去定制，所以都用默认配置，习惯了就好”。其实道理很简单，算笔账就清楚了，除非你是 SA 每天管理上千台服务器，程序员的话，每天接触的开发服务器也就五台以内。既然 90% 的利益都在那三五台机器上，还在纠结 10% 的事情，这就叫不明智。

还有人担心这 10% 的时间偶尔到裸环境下不适应了，所以拒绝 90% 的时间使用高级配置。这是我听过最荒谬的理由，我天天自己开车上下班，偶尔骑下自行车我也不会忘记怎么骑车。更不因为偶尔需要时怕不会骑了而把汽车卖了每天都坚持骑单车，或者干脆就拒绝学汽车驾驶，拒绝提高自己的车技。我路由器上连 bash 都没有，只有个 busybox 的残缺 shell ，照着理由我要去迁就路由器么？这种说法要不就是看不清楚自己核心利益在哪里，要不就是没体验过汽车快起来可以比单车快几倍。

何况不管是程序员还是 SA，做好配置的同步工作也就行了。如果可以花固定的时间，让终端工作效率提升一倍以上，这种一次性的投资为何不做呢？所以接下来讨论下终端环境下各种配置应该如何管理，如何同步的。

<!--more-->

#### 原则 1：托管你的配置

配置需要反复锤炼和迭代，迭代就需要持久化的文件托管和版本控制，不能说每次都凭借记忆从头写一次，这样你的配置永远积累不下来。

所以从 Github 上新建个 config 项目开始，把各种：编辑器，shell，readline，tmux 配置一点点的放上去，新环境中克隆下来，放到一个安全的位置，比如 `~/.local/config` 下面。

#### 原则 2：同步到常用服务器即可

如果新登陆一台新服务器，只是为了临时操作一下，那大可不必同步你的配置。只有你判断今后一段时间会反复的在这台服务器上工作，那么就花两分钟同步一下，你甚至可以把你配置的克隆和部署写到一个 `bootstrap.sh` 文件上，curl 下来一执行，一句话的事情：

```bash
sh -c "$(curl -fsSL https://。。。/bootstrap.sh)"
```

这个脚本将会建立必要的目录，克隆你的配置，再做一些必要的初始化，来到一台新机器就跑这么一行代码，还有人觉得比你部署其他程序复杂么？

#### 原则 3：尽量少用软连接

那么最基本的 `.bashrc` 文件应该怎么同步呢？第一种方法是将该文件做成一个软连接指向你仓库里的实际的 `bashrc` 文件；第二种做法是在配置仓库中写一个 `update.sh` 脚本，自动拷贝仓库里的 bashrc 过去覆盖 `~/.bashrc` 。

前一种方式的问题是本地想做一些临时修改就容易改动到仓库里的源文件把仓库弄脏，这样你后面更新的时候就需要 merge，或者选择先提交。第二种方式的问题是每次更新了仓库，运行 `update.sh` 就会把原来的 `~/.bashrc` 给覆盖掉了，所有本地化配置和临时修改也就全部都没了。


#### 如何同步配置呢？

更合理的做法是新建一个：init.sh 用仓库托管起来，而本地 `~/.bashrc` 末尾加一句话：

```bash
source ~/.local/xxx/init.sh 
```

即可，这个给文件末尾追加一句话的事情，可以让前面的 bootstrap.sh 来承担。

这样你的通用配置被放到了仓库里的 init.sh 里面，而本地化的一些临时配置，还可以接着在 `~/.bashrc` 其他部分写，同时改写 `~/.bashrc` 不会把 config 仓库弄脏；而更新 config 仓库也不会把本地配置覆盖没。

更重要的是，init.sh 可以写成同时兼容：sh, bash, zsh, dash 的模式，每个 shell的配置里面只要 source 它一下就行了，那么 init.sh 里面即可写通用所有 shell 的一些初始化工作，又可以针对不同的 shell 写一些初始化配置。

对于实验性的新配置，写到本地配置里即可，等你用一段时间，觉得好用了，再把它挪到公共配置仓库里固化起来。这样随着时间的积累，你的 init.sh 积累的配置越来越多，shell 越来越顺手。

所以你并不需要托管你的 bashrc，你需要的是一个有版本管理的，可以四处同步的 init.sh。有恒产才能有恒心，如果你每换一个环境都要从头写你的配置，但当然没什么心情写下去；而如果你把配置固化托管到 github 上，四处都能同步使用，你才会隔三岔五的想着去优化迭代。


#### 文末参考

初期建议全部写在 init.sh 里面的，后面复杂了可以进行模块化拆分，现在我的 init.sh 现在基本就是一个入口。可以到 github 上搜索 bash 类型，星星最高的配置，或者按名字 dotfiles 搜索，我的就不拿出来献丑了，写的比我好的多的是。

Shell 方面我唯一可以一看的项目是我的 《Bash 中文速查表》：

https://github.com/skywind3000/awesome-cheatsheets/blob/master/languages/bash.sh

目前全网最全的 bash 简明帮助，或许在你写配置时可以参考用到。


附：我当前的 init.sh （其实没啥内容了，已经被拆分成只剩一个入口了）

```bash
# 交互式模式的初始化脚本
# 防止被加载两次
if [ -z "$_INIT_SH_LOADED" ]; then
    _INIT_SH_LOADED=1
else
    return
fi

# 如果是非交互式则退出，比如 bash test.sh 这种调用 bash 运行脚本时就不是交互式
# 只有直接敲 bash 进入的等待用户输入命令的那种模式才成为交互式，才往下初始化
case "$-" in
    *i*) ;;
    *) return
esac

# 将个人 ~/.local/bin 目录加入 PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# 判断 ~/.local/etc/config.sh 存在的话，就 source 它一下
if [ -f "$HOME/.local/etc/config.sh" ]; then
    . "$HOME/.local/etc/config.sh"
fi

# 判断 ~/.local/etc/local.sh 存在的话，就 source 它一下
if [ -f "$HOME/.local/etc/local.sh" ]; then
    . "$HOME/.local/etc/local.sh"
fi

# 整理 PATH，删除重复路径
if [ -n "$PATH" ]; then
    old_PATH=$PATH:; PATH=
    while [ -n "$old_PATH" ]; do
        x=${old_PATH%%:*}      
        case $PATH: in
           *:"$x":*) ;;         
           *) PATH=$PATH:$x;;  
        esac
        old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
fi

export PATH

# 如果是 bash/zsh 的话，source 一下 ~/.local/etc/function.sh
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    # run script for interactive mode of bash/zsh
    if [[ $- == *i* ]] && [ -z "$_INIT_SH_NOFUN" ]; then
        if [ -f "$HOME/.local/etc/function.sh" ]; then
            . "$HOME/.local/etc/function.sh"
        fi
    fi
fi

# 如果是登陆模式，那么 source 一下 ~/.local/etc/login.sh
if [ -n "$BASH_VERSION" ]; then
    if shopt -q login_shell; then
        if [ -f "$HOME/.local/etc/login.sh" ] && [ -z "$_INIT_SH_NOLOG" ]; then
            . "$HOME/.local/etc/login.sh"
        fi
    fi
elif [ -n "$ZSH_VERSION" ]; then
    if [[ -o login ]]; then
        if [ -f "$HOME/.local/etc/login.sh" ] && [ -z "$_INIT_SH_NOLOG" ]; then
            . "$HOME/.local/etc/login.sh"
        fi
    fi
fi
```
