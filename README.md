## Session 1, deliverable 2: Multi-Stage Builds
> Create a Dockerfile with (at least) the stages below.
> * Download/Clone Source Code” Stage
> * “Build/Compile” Stages (OracleLinux and Debian)
>    * Tip: You’ll need “make” and “golang” system packages
>    * Tip: Use bitnami/minideb-extras-base and oraclelinux-extras-base
> * “Runtime” Stages (OracleLinux and Debian)
> The resulting Dockerfile should allow me to create a platform-specific container for the latest version of etcd. 

#### Use
```bash
$ docker build . -t etcd:debian --target target-debian
$ docker build . -t etcd:ol --target target-ol
$ docker run --rm etcd:debian
$ docker run --rm etcd:debian etcdctl
$ docker run --rm etcd:ol
$ docker run --rm etcd:ol etcdctl
```