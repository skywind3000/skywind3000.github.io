#! /bin/sh

set -e
set -x
export DEBIAN_FRONTEND=noninteractive


##
## packages
##
packages="python-dev python3 python3-dev python3-setuptools python-setuptools"
packages="$packages supervisor python-m2crypto gcc g++ make automake autoconf"
packages="$packages bison flex git subversion zsh tmux build-essential"
packages="$packages python-libnacl pkg-config lua5.3"
packages="$packages libncurses5-dev libncursesw5-dev"


##
## install packages
##
apt-get install -y --no-install-recommends --auto-remove --purge ${packages}

##
## pip
##
cd ~root
mkdir -p install
cd install

wget https://bootstrap.pypa.io/get-pip.py

python2 get-pip.py
python3 get-pip.py


pip2 install requests flask requests[socks] pygments
pip3 install requests flask requests[socks] pygments

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
echo "INIT_LUA=/usr/bin/lua5.3" >> ~/.bashrc
echo "source ~/.local/etc/init.sh" >> ~/.bashrc


