# Docker Images for Building Ceph

Docker images containing dependencies for building Ceph. Why? To 
speedup containerized Ceph development workflows. To build an image:

```bash
docker build \
  --build-arg UBUNTU_VERSION="bionic" \
  --build-arg GIT_URL="https://github.com/ceph/ceph" \
  --build-arg GIT_REF="nautilus" \
  --tag myrepo/ceph-builder:bionic-nautilus ./
```

To add extra dependencies, an `EXTRA_PKGS` argument can also be 
provided, which should include a space-separated list of package names 
that need to be installed in addition to what [`install-deps.sh`][id] 
provides.

[id]: https://github.com/ceph/ceph/blob/2db4960/install-deps.sh

## Pre-built Images

We maintain the [`popperized/ceph-builder`][dockerhub] Docker registry 
repository with tags for distinct versions of Ceph (`mimic`, 
`nautilus` and `luminous`) on Ubuntu 18.04.

## Usage

To build Ceph using these images:

```bash
docker run \
  -v "/path/to/ceph:/ceph" -e CEPH_SRC_DIR="/ceph" \
  popperized/ceph-builder:nautilus-bionic \
    target1 target2
```

In the above example, we assume that the `/path/to/ceph/` folder 
contains a local working directory of the Ceph repository. We 
bind-mount this folder and map it to `/ceph` inside the container. We 
then specify the CMake targets we want to build (`target1`, `target2` 
in the example). The [`ENTRYPOINT`](./entrypoint.sh) to the image will 
create a `build/` directory inside the Ceph folder if it doesn't exist 
and invoke `cmake`, followed by `make`. The following variables are 
used to control the logic of this entrypoint script:

  * `CMAKE_FLAGS`. Flags that are passed to `cmake` when configuring 
    the project.

  * `CMAKE_RECONFIGURE`. If the variable is defined (can take any 
    value), forces a reconfiguration of the project by calling `cmake` 
    again. Default: unset.

  * `CMAKE_CLEAN`. If defined (can take any value), removes the 
    `build/` directory and invokes `cmake` on a freshly created (and 
    empty) `build/` folder. Default: unset.

  * `BUILD_THREADS`. Number of threads given to `make` (via the `-j` 
    flag). Default: all cores in the machine.

For example, the following is a minimal build (OSD and monitor only) 
on a 32-core machine:

```bash
docker run --rm \
  -v "/path/to/ceph:/ceph" \
  -e CEPH_SRC_DIR="/ceph" \
  -e BUILD_THREADS=32 \
  -e CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=MinSizeRel -DWITH_RBD=OFF -DWITH_CEPHFS=OFF -DWITH_RADOSGW=OFF -DWITH_MGR=OFF -DWITH_LEVELDB=OFF -DWITH_MANPAGE=OFF -DWITH_RDMA=OFF -DWITH_OPENLDAP=OFF -DWITH_FUSE=OFF -DWITH_LIBCEPHFS=OFF -DWITH_KRBD=OFF -DWITH_LTTNG=OFF -DWITH_BABELTRACE=OFF -DWITH_TESTS=OFF -DWITH_MGR_DASHBOARD_FRONTEND=OFF -DWITH_SYSTEMD=OFF -DWITH_SPDK=OFF" \
  popperized/ceph-builder:nautilus-bionic \
    vstart
```

## Run a Single-node Cluster

This same builder image can be used to run a single-node cluster. For 
example, assuming we built the minimal configuration shown above:

```bash
cd myproject/

docker run --rm -ti \
  -v "/path/to/ceph:/ceph" \
  --entrypoint=/bin/bash \
  popperized/ceph-builder:nautilus-bionic \
```

The above puts us inside a container. There, we can type:

```bash
cd /ceph/build
MON=1 OSD=1 MGR=0 MDS=0 ../src/vstart.sh -d -X -n
bin/ceph -s
```

For more on how to use the `vstart.sh` script, see 
[here](http://docs.ceph.com/docs/mimic/dev/quick_guide/).

[dockerhub]: https://hub.docker.com/r/popperized/ceph-builder/tags
