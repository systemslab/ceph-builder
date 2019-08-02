ARG OS_VERSION=bionic
FROM ubuntu:${OS_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_URL="https://github.com/ceph/ceph"
ARG GIT_REF="master"
ARG EXTRA_PKGS=""

RUN apt-get update && \
    apt-get install -y git gnupg2 ccache && \
    git clone --branch $GIT_REF --depth 1 $GIT_URL ceph && \
    cd ceph && \
    ./install-deps.sh && \
    sh -c 'if [ -n "$EXTRA_PKGS" ]; then apt-get install -y "$EXTRA_PKGS"; fi' && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* debian/

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
