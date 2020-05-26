FROM centos:7.8.2003

ARG GIT_URL="https://github.com/uccross/skyhookdm-ceph"
ARG GIT_REF="skyhook-luminous"
ARG EXTRA_PKGS=""

ADD . /

RUN ./install-preq.sh && \
    git clone --branch $GIT_REF --depth 1 $GIT_URL ceph && \
    cd ceph && \
    ./install-deps.sh && \
    sh -c 'if [ -n "$EXTRA_PKGS" ]; then apt-get install -y "$EXTRA_PKGS"; fi' && \
    yum clean all

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
