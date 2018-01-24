#! /bin/sh

adduser --disabled-password --gecos "" skywind
cd ~skywind

mkdir -p .ssh .vim
mkdir -p software github work document develop 
mkdir -p tmp

chown -R skywind:skywind .ssh .vim *
chmod 700 .ssh

cd .vim
git clone https://github.com/skywind3000/vim.git

chown -R skywind:skywind vim

su skywind -c "sh ~/.vim/vim/etc/init.sh"
su skywind -c "touch ~/.vimrc"

echo "so ~/.vim/vim/vimrc.unix" >> .vimrc
echo "" >> .bashrc
echo "source ~/.local/etc/init.sh" >> .bashrc

chown skywind:skywind .vimrc .bashrc




