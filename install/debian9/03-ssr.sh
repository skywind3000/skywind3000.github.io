#! /bin/sh

cd /home/data/software
git clone https://github.com/skywind3000/ssr.git

cd /etc/supervisor/conf.d

echo "[program:ssr]" > ssr.conf


