#! /bin/sh

cd /home/data/software
git clone https://github.com/skywind3000/ssr.git

cd /etc/supervisor/conf.d

echo "[program:ssr]" > ssr.disable
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p XXXX -k XXXXXXX -m aes-256-cfb -O origin -o plain --fast-open --workers 2" >> ssr.disable
echo "autorestart=true" >> ssr.disable
echo "user=nobody" >> ssr.disable

echo "[program:ssr-km]" > ssr-km.disable
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p XXXX -k XXXXXXX -m aes-128-cfb  -o tls1.2_ticket_auth --fast-open --workers 2" >> ssr-km.disable
echo "autorestart=true" >> ssr-km.disable
echo "user=nobody" >> ssr-km.disable

echo "[program:ssr-test]" > ssr-test.disable
echo "command=/usr/bin/python2 /home/data/software/ssr/shadowsocks/server.py -p XXXX -k XXXXXXX -m aes-256-cfb -O origin -o plain --fast-open --workers 2" >> ssr-test.disable
echo "autorestart=true" >> ssr-test.disable
echo "user=nobody" >> ssr-test.disable

# supervisorctl reload

cd /etc/cron.d
echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr" > restart
echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr-test" >> restart
echo "32 6 * * *      root    /usr/bin/supervisorctl restart ssr-km" >> restart

cd
