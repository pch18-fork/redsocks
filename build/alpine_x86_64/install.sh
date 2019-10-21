apk update
apk add libevent
cp ./redsocks /usr/bin/redsocks
cp ./redsocks.conf /etc/redsocks.conf
cp ./redsocks.service /etc/init.d/redsocks
chmod +x /usr/bin/redsocks
chmod +x /etc/init.d/redsocks
adduser -u 12345 -G root -D -g redsocks -h /usr/bin/redsocks -s /sbin/nologin redsocks
chown redsocks /usr/bin/redsocks
rc-update add redsocks boot

apk add iptables # 安装 iptables
rm -f /etc/profile.d/proxy.sh

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

iptables -t nat -N REDSOCKS
iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN # 出口内网不走代理
iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN # 出口内网不走代理
iptables -t nat -A REDSOCKS -d 172.0.0.0/8 ! -i eth0 -j RETURN # 出口内网不走代理

iptables -t nat -A REDSOCKS -d proxy.itc.kansai-u.ac.jp -j RETURN
iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-port 12345
iptables -t nat -A REDSOCKS -p udp -j REDIRECT --to-port 12346
iptables -t nat -I PREROUTING -p tcp -j REDSOCKS
iptables -t nat -I OUTPUT -p tcp -j REDSOCKS

service iptables save
cp /etc/iptables/rules-save /etc/iptables/rules-save_origin
rc-update add iptables boot

