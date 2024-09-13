#! /bin/sh

set -e
set -x
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y --fix-missing --fix-broken


##
## packages
##
packages="sudo adduser curl ca-certificates openssl wget lv vim man-db whiptail net-tools unzip"
# packages="$packages etckeeper"
packages="$packages locales tzdata"
packages="$packages localepurge"
# packages="$packages sysvinit-core systemd-sysv- systemd-"
packages="$packages openssh-server rsyslog cron"


##
## install packages
##
apt-get install -y --no-install-recommends --auto-remove --purge ${packages}


##
## configure locales
##
if [ -f /etc/default/locale ]; then
  echo "LANG=en_US.UTF-8"              >> /etc/default/locale
fi
if [ -f /etc/locale.gen ]; then
  sed -i -e 's@^# \(en_US.UTF-8 UTF-8\)@\1@' /etc/locale.gen
  sed -i -e 's@^# \(zh_CN.UTF-8 UTF-8\)@\1@' /etc/locale.gen
  locale-gen
else
  echo "en_US.UTF-8 UTF-8"    > /etc/locale.gen
  echo "zh_CN.UTF-8 UTF-8"   >> /etc/locale.gen
  locale-gen
fi


##
## configure timezone
##
echo "Asia/Shanghai" > /etc/timezone
# workaround: see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=813226
[ -L /etc/localtime ] && rm /etc/localtime
dpkg-reconfigure -f noninteractive tzdata



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


##
## skywind
##

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
echo "INIT_LUA=/usr/bin/lua5.3" >> .bashrc
echo "source ~/.local/etc/init.sh" >> .bashrc

chown skywind:skywind .vimrc .bashrc

echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEA2yNZF/SKiYaFKHlpi4HoSxDMIDJfJsjL4+ZbdkNxxscSY02O95txYkwNrQJNLRPVCMy+d5027AuKvT/yKptzJ1POszxUGXqCE/cAb8idAptYu2r1FpWvPzdK1l7UmDrUzr0frvk64hlyeOPjvQ7bFko96NI5UuCFnCpFcC8oTnM= LinWei" > ~skywind/.ssh/authorized_keys
echo "skywind ALL=(ALL) /sbin/shutdown, /sbin/reboot, /bin/cat, /usr/bin/head, /usr/bin/tail, /sbin/ifconfig, /usr/bin/apt-get, /usr/local/bin/emake, /usr/bin/easy_install, /usr/bin/aptitude, /bin/netstat, /bin/mount, /bin/umount, /usr/sbin/tcpkill, /usr/bin/pip, /usr/bin/docker, /usr/local/bin/pip, /usr/sbin/apache2ctl, /usr/bin/apt, /usr/bin/docker, /usr/local/bin/pip3, /usr/bin/npm, /usr/bin/aptitude, /usr/bin/gem" > /etc/sudoers.d/skywind

chown skywind:skywind .ssh/authorized_keys



