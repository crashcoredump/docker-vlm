#!/bin/bash

[ -d /dev/net ] || /usr/bin/sudo mkdir -p /dev/net

[ -c /dev/net/tun ] || /usr/bin/sudo mknod /dev/net/tun c 10 200

/usr/bin/sudo chmod 666 /dev/net/tun

/usr/bin/sudo ip tuntap add dev tap0 mode tap
/usr/bin/sudo ip addr add 192.168.2.1/24 dev tap0
/usr/bin/sudo ip link set dev tap0 up

cd /home/genera

vncserver && /home/genera/genera 2>&1
