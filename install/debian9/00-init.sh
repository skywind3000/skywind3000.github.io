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



