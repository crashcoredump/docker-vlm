# About

This is a Dockerized installation of Symbolics OpenGenera.

# WARNING!

At the moment, this ONLY runs on Unix hosts, and does not support
Docker or Docker-Machine running on OS X. I'm still working on getting
that to work.

# To Build

    docker build -t docker-vlm .

# To Run

To run the VLM under Docker, please use the included `dvlm` utility.

For a summary of help, type `dvlm -h`.

In short, dvlm is a wrapper around docker that knows how to build and
run new containers with the appropriate settings. It hides some of
Docker's 

`dvlm` uses a hack to get X11 working. It maps the X11 UNIX domain
socket directory into the Docker machine, allowing it to be shared by
both your main display and by genera. If you do not have the X11
socket directory `/tmp/.X11-unix`, this hack will not work, and `dvlm`
will refuse to run.

The two main options are available when creating a new container:

- `-g`, which can point the VLM at a directorhy containing a compiled
  `genera` binary on the local host, 

- `-s`, which can point the VLM at a directory containing `sys.sct`
  on the local host.

Note that these options only apply when you do not have a container
yet! On subsequent runs they will be ignored (because they only make
sense at container creation time)

# Notes About the Install

- The Docker image includes a Genera 8.5 world with a pre-defined Site
  named "Docker".

- There is only one UNIX user, named `genera`. You may log into Genera
  with the password `xyzzy`. This password is hard-coded. If you want
  to change it, edit the definition of
  `RPC::USERNAME-AND-PASSWORD-VALID-P` in `nfs/authentication.lisp`

- The docker VLM virtual machine is named GENERA and has IP address
  192.168.2.2.

- The docker host is named GENERA-VLM and has IP address 192.168.2.1.

- NFS shares the entire UNIX root file system, as is normal with Open
  Genera.
