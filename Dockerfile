ARG UBUNTU_VERSION=bionic
FROM ubuntu:${UBUNTU_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG GITHUB_REPO="ceph/ceph"
ARG GIT_REF="master"
ARG INSTALL_SCRIPT=""

RUN apt-get update && \
    apt-get install -y curl && \
    curl -LO https://raw.githubusercontent.com/$GITHUB_REPO/$GIT_REF/install-deps.sh && \
    curl -LO https://raw.githubusercontent.com/$GITHUB_REPO/$GIT_REF/control && \
    mkdir debian && \
    mv control debian && \
    chmod +x install-deps.sh && \
    ./install-deps.sh && \
    sh -c 'if [ -f "$INSTALL_SCRIPT" ]; then source "$INSTALL_SCRIPT"; fi' && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* debian/
