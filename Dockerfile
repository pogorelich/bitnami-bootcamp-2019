# Download/Clone Source Code
FROM bitnami/minideb:stretch AS download
RUN install_packages git make ca-certificates curl
RUN curl https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz | tar -xzf - -C /usr/local
ENV PATH="/usr/local/go/bin:$PATH" CGO_ENABLED=0
RUN cd / && git clone http://github.com/etcd-io/etcd.git

# Build/Compile for Debian
FROM bitnami/minideb:stretch AS debian-compile
RUN install_packages git make ca-certificates curl
COPY --from=download /etcd /etcd
RUN curl https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz | tar -xzf - -C /usr/local
ENV PATH="/usr/local/go/bin:$PATH" CGO_ENABLED=0
RUN cd /etcd/ && make build

# Build/Compile for OracleLinux
FROM oraclelinux:7-slim AS ol-compile
RUN yum install -y tar git make ca-certificates curl
COPY --from=download /etcd /etcd
RUN curl https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz | tar -xzf - -C /usr/local
ENV PATH="/usr/local/go/bin:$PATH" CGO_ENABLED=0
RUN cd /etcd/ && make build

# Runtime for Debian
FROM scratch AS target-debian
COPY --from=debian-compile /etcd/bin/etcd /bin/
COPY --from=debian-compile /etcd/bin/etcdctl /bin/
CMD ["etcd"]

# Runtime for OracleLinux
FROM scratch AS target-ol
COPY --from=ol-compile /etcd/bin/etcd /bin/
COPY --from=ol-compile /etcd/bin/etcdctl /bin/
CMD ["etcd"]