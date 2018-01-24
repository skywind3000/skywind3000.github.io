#! /bin/sh

set -e
set -x
export DEBIAN_FRONTEND=noninteractive


##
## packages
##
packages="python-dev python3 python3-dev python3-setuptools python-setuptools"
packages="$packages supervisor python-m2crypto gcc g++ make automake autoconf"
packages="$packages bison flex git subversion zsh tmux build-essential "


##
## install packages
##
apt-get install -y --no-install-recommends --auto-remove --purge ${packages}

##
## pip
##
easy_install3 pip
easy_install pip

pip3 install --upgrade pip
pip install --upgrade pip

pip3 install requests flask
pip install requests flask

cd ~root
mkdir -p software github tmp install
mkdir -p /home/data

cd /home/data
mkdir -p script software var lib

cd ~root
mkdir -p .vim
cd .vim

git clone https://github.com/skywind3000/vim.git
cd vim/etc
sh update.sh

cd ~root
echo "so ~/.vim/vim/vimrc.unix" >> ~/.vimrc

echo "" >> ~/.bashrc
echo "source ~/.local/etc/init.sh" >> ~/.bashrc


