#! /bin/sh
# wget https://skywind3000.github.io/install/debian9/99-proxy.sh
# sh 99-proxy.sh PASSWD

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
packages="$packages python-libnacl"


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

su skywind -l -c "sh ~skywind/.vim/vim/etc/init.sh"
su skywind -l -c "touch ~skywind/.vimrc"
su skywind -l -c "cd ~skywind/.vim/vim/etc; sh update.sh"

cd ~skywind

echo "so ~/.vim/vim/vimrc.unix" >> .vimrc
echo "" >> .bashrc
echo "source ~/.local/etc/init.sh" >> .bashrc

chown skywind:skywind .vimrc .bashrc

echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEA2yNZF/SKiYaFKHlpi4HoSxDMIDJfJsjL4+ZbdkNxxscSY02O95txYkwNrQJNLRPVCMy+d5027AuKvT/yKptzJ1POszxUGXqCE/cAb8idAptYu2r1FpWvPzdK1l7UmDrUzr0frvk64hlyeOPjvQ7bFko96NI5UuCFnCpFcC8oTnM= LinWei" > ~skywind/.ssh/authorized_keys
echo "skywind ALL=(ALL) /sbin/shutdown, /sbin/reboot, /bin/cat, /usr/bin/head, /usr/bin/tail, /sbin/ifconfig, /usr/bin/apt-get, /usr/local/bin/emake, /usr/bin/easy_install, /usr/bin/aptitude, /bin/netstat, /bin/mount, /bin/umount, /usr/sbin/tcpkill, /usr/bin/pip, /usr/bin/docker, /usr/local/bin/pip, /usr/sbin/apache2ctl, /usr/bin/apt, /usr/bin/docker, /usr/local/bin/pip3, /usr/bin/npm, /usr/bin/aptitude, /usr/bin/gem" > /etc/sudoers.d/skywind

chown skywind:skywind .ssh/authorized_keys


# Proxy

cd /home/data/software
git clone https://github.com/skywind3000/ssr.git

cd /etc/supervisor/conf.d

PASSWD="${1:-XXXXXX}"

echo "[program:ssr]" > ssr.conf
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p 8081 -k $PASSWD -m chacha20 -O origin -o plain --fast-open --workers 2" >> ssr.conf
echo "autorestart=true" >> ssr.conf
echo "user=nobody" >> ssr.conf

echo "[program:ssr-km]" > ssr-km.disable
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p 8081 -k XXXXXXX -m aes-128-cfb  -o tls1.2_ticket_auth --fast-open --workers 2" >> ssr-km.disable
echo "autorestart=true" >> ssr-km.disable
echo "user=nobody" >> ssr-km.disable

echo "[program:ssr-test]" > ssr-test.disable
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p XXXX -k XXXXXXX -m aes-256-cfb -O origin -o plain --fast-open --workers 2" >> ssr-test.disable
echo "autorestart=true" >> ssr-test.disable
echo "user=nobody" >> ssr-test.disable

supervisorctl reload

cd /etc/cron.d
echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr" > restart
# echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr-test" >> restart
# echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr-km" >> restart

cd
