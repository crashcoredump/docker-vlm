# About

This is a Dockerized installation of Symbolics OpenGenera.

# WARNING!

At the moment, this ONLY runs on Unix hosts, and does not support
Docker or Docker-Machine running on OS X. I'm still working on getting
that to work.

Note, also, that this procedure REQUIRES that your X11 sockets be
under /tmp/.X11-unix. If it's not, you'll need to edit the run
command to map to the correct directory.

# To Build

    docker build -t docker-vlm .

# To Run

    docker create --name docker-vlm 

    docker run -ti --privileged \
        --env="DISPLAY" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -P docker-vlm

# Notes

The Docker image includes a Genera 8.5 world with a pre-defined Site
named "Docker".

There is only one UNIX user, named 'genera'. You may log into Genera
with the password 'xyzzy'. This password is hard-coded. If you want to
change it, edit the definition of `RPC::USERNAME-AND-PASSWORD-VALID-P`
in `nfs/authentication.lisp`

NFS shares the entire UNIX root file system, as is normal with Open
Genera.
