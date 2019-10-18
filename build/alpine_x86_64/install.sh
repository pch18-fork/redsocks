apk update
apk add libevent
cp ./redsocks /usr/bin/redsocks
cp ./redsocks.conf /etc/redsocks.conf
cp ./redsocksd /etc/init.d/redsocksd
chmod +x /usr/bin/redsocks
chmod +x /etc/init.d/redsocksd
rc-update add redsocksd boot

apk add iptables
iptables -t nat -A OUTPUT -d 192.168.0.0/16 -j RETURN
iptables -t nat -A OUTPUT -d 127.0.0.0/8 -j RETURN
iptables -t nat -A OUTPUT -d proxy.itc.kansai-u.ac.jp -j RETURN
iptables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 12345
iptables -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 12345
service iptables save
rc-update add iptables boot

rm -f /etc/profile.d/proxy.sh
