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

su skywind -c "sh ~skywind/.vim/vim/etc/init.sh"
su skywind -c "touch ~skywind/.vimrc"
su skywind -c "cd ~skywind/.vim/vim/etc; sh update.sh"

cd ~skywind

echo "so ~/.vim/vim/vimrc.unix" >> .vimrc
echo "" >> .bashrc
echo "source ~/.local/etc/init.sh" >> .bashrc

chown skywind:skywind .vimrc .bashrc

echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEA2yNZF/SKiYaFKHlpi4HoSxDMIDJfJsjL4+ZbdkNxxscSY02O95txYkwNrQJNLRPVCMy+d5027AuKvT/yKptzJ1POszxUGXqCE/cAb8idAptYu2r1FpWvPzdK1l7UmDrUzr0frvk64hlyeOPjvQ7bFko96NI5UuCFnCpFcC8oTnM= LinWei" > ~skywind/.ssh/authorized_keys
echo "skywind ALL=(ALL) /sbin/shutdown, /sbin/reboot, /bin/cat, /usr/bin/head, /usr/bin/tail, /sbin/ifconfig, /usr/bin/apt-get, /usr/local/bin/emake, /usr/bin/easy_install, /usr/bin/aptitude, /bin/netstat, /bin/mount, /bin/umount, /usr/sbin/tcpkill, /usr/bin/pip, /usr/bin/docker, /usr/local/bin/pip, /usr/sbin/apache2ctl, /usr/bin/apt, /usr/bin/docker, /usr/local/bin/pip3, /usr/bin/npm, /usr/bin/aptitude, /usr/bin/gem" > /etc/sudoers.d/skywind

chown skywind:skywind .ssh/authorized_keys



