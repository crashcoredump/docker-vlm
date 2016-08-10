#!/bin/bash

# Ensure the hosts entries exist

if ! grep "192.168.2.1" /etc/hosts ; then
    sudo sh -c 'echo "192.168.2.1 genera-vlm" >> /etc/hosts'
fi

if ! grep "192.168.2.2" /etc/hosts ; then
    sudo sh -c 'echo "192.168.2.2 genera" >> /etc/hosts'
fi

[ -d /dev/net ] || /usr/bin/sudo mkdir -p /dev/net

[ -c /dev/net/tun ] || /usr/bin/sudo mknod /dev/net/tun c 10 200

[ -d /run/sendsigs.omit.d ] || /usr/bin/sudo mkdir -p /run/sendsigs.omit.d

/usr/bin/sudo chmod 666 /dev/net/tun

/usr/bin/sudo ip tuntap add dev tap0 mode tap
/usr/bin/sudo ip addr add 192.168.2.1/24 dev tap0
/usr/bin/sudo ip link set dev tap0 up

/usr/bin/sudo /etc/init.d/inetutils-inetd start
/usr/bin/sudo /etc/init.d/rpcbind start
/usr/bin/sudo /etc/init.d/nfs-kernel-server start
/usr/bin/sudo exportfs -avr

cd /home/genera

rm -f /tmp/.X1-lock
rm -rf /tmp/.X11-unix

tightvncserver &

/home/genera/genera 2>&1
