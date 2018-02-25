#! /bin/sh

cd /home/data/software
git clone https://github.com/skywind3000/ssr.git

cd /etc/supervisor/conf.d

echo "[program:ssr]" > ssr.conf
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p XXXX -k XXXXXXX -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible --fast-open --workers 2" >> ssr.conf
echo "autorestart=true" >> ssr.conf
echo "user=nobody" >> ssr.conf

echo "[program:ssr-km]" > ssr-km.conf
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p XXXX -k XXXXXXX -m aes-128-cfb  -o tls1.2_ticket_auth --fast-open --workers 2" >> ssr-km.conf
echo "autorestart=true" >> ssr-km.conf
echo "user=nobody" >> ssr-km.conf

echo "[program:ssr-test]" > ssr-test.conf
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p XXXX -k XXXXXXX -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible --fast-open --workers 2" >> ssr-test.conf
echo "autorestart=true" >> ssr-test.conf
echo "user=nobody" >> ssr-test.conf

# supervisorctl reload

cd /etc/cron.d
echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr" > restart
echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr-test" >> restart
echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr-km" >> restart

cd
