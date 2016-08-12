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

# These steps are necessary for VNC when re-starting a container
sudo rm -f /tmp/.X1-lock
sudo rm -rf /tmp/.X11-unix

cd /home/genera

echo
echo "**************************************************************************"
echo "*                                                                         *"
echo "*  Genera is running under VNC. Please connect your VNC client to         *"
echo "*  the IP address of your Docker Machine, port 5901 / display 1           *"
echo "*  (typically 192.168.99.100:5901 or 192.168.99.100:1 if running under    *"
echo "*  Docker Machine, depending on VNC client.)                              *"
echo "*                                                                         *"
echo "*  The VNC password is: genera                                            *"
echo "*                                                                         *"
echo "***************************************************************************"
echo

tightvncserver -geometry 1300x1080 && /home/genera/bin/genera 2>&1
