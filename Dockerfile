FROM ubuntu:16.04
MAINTAINER Seth Morabito <seth@loomcom.com>

EXPOSE 5901

ENV TERM vt100

RUN apt-get update && \
    apt-get install -y tightvncserver mwm sudo \
    inetutils-inetd xterm telnet nfs-kernel-server

RUN mkdir -p /home/genera && \
    mkdir -p /home/genera/.vnc

COPY vnc-passwd /home/genera/.vnc/passwd
COPY genera /home/genera
COPY run-genera.sh /home/genera
COPY dot-VLM /home/genera/.VLM
COPY dist.vlod /home/genera/dist.vlod
COPY VLM_debugger /home/genera/VLM_debugger
COPY Xsession /home/genera/.Xsession
COPY var_lib_symbolics.tar.gz /var/lib
COPY exports /etc/exports

RUN export uid=1000 gid=1000 && \
    mkdir -p /etc/sudoers.d && \
    echo "genera:x:${uid}:${gid}:Genera,,,:/home/genera:/bin/bash" >> /etc/passwd && \
    echo "genera:x:${uid}:" >> /etc/group && \
    echo "genera ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/genera && \
    echo "daytime stream tcp nowait root internal" >> /etc/inetd.conf && \
    echo "time  stream tcp nowait root internal" >> /etc/inetd.conf && \
    echo "daytime dgram udp wait root internal" >> /etc/inetd.conf && \
    echo "time dgram udp wait root internal" >> /etc/inetd.conf && \
    cd /var/lib && tar xvf var_lib_symbolics.tar.gz && \
    chmod 0440 /etc/sudoers.d/genera && \
    chmod 0700 /home/genera/.vnc && \
    chown ${uid}:${gid} -R /home/genera

USER genera

ENV DISPLAY localhost:1.0
ENV HOME /home/genera
ENV USER genera

CMD /home/genera/run-genera.sh
