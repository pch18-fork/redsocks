chmod +x ./redsocks
chmod +x ./redsocksd
cp ./redsocks /usr/bin/redsocks
cp ./redsocks.conf /etc/redsocks.conf
cp ./redsocksd /etc/init.d/redsocksd
rc-update add redsocksd boot