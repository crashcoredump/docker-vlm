#!/bin/bash

# Ensure the hosts entries exist

if ! grep "192.168.2.1" /etc/hosts ; then
    sudo sh -c 'echo "192.168.2.1 genera-vlm" >> /etc/hosts'
fi

if ! grep "192.168.2.2" /etc/hosts ; then
    sudo sh -c 'echo "192.168.2.2 genera" >> /etc/hosts'
fi

[ -d /dev/net ] || sudo mkdir -p /dev/net

[ -c /dev/net/tun ] || sudo mknod /dev/net/tun c 10 200

[ -d /run/sendsigs.omit.d ] || sudo mkdir -p /run/sendsigs.omit.d

sudo chmod 666 /dev/net/tun

sudo ip tuntap add dev tap0 mode tap
sudo ip addr add 192.168.2.1/24 dev tap0
sudo ip link set dev tap0 up

sudo /etc/init.d/inetutils-inetd start
sudo /etc/init.d/rpcbind start
sudo /etc/init.d/nfs-kernel-server start
sudo exportfs -avr

cd /home/genera

/home/genera/genera 2>&1
