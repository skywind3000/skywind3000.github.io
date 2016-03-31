#!/bin/sh

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
cd $DIR

mkdir -p ~/.vim
ln -s $DIR/vimneat.vim ~/.vim/vimneat.vim
ln -s $DIR/vimmake.vim ~/.vim/vimmake.vim
ln -s $DIR/skywind.vim ~/.vim/skywind.vim
ln -s $DIR/backup.vim ~/.vim/backup.vim
ln -s $DIR/plugin ~/.vim/plugin
ln -s $DIR/autoload ~/.vim/autoload
ln -s $DIR/doc ~/.vim/doc
ln -s $DIR/color ~/.vim/color
ln -s $DIR/syntax ~/.vim/syntax


