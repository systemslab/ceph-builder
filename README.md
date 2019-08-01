# Docker Images for Building Ceph

Docker images containing build dependencies for Ceph. Why? To speedup 
Ceph development workflows. To build an image:

```bash
docker build \
  --build-arg UBUNTU_VERSION="bionic" \
  --build-arg GIT_URL="https://github.com/ceph/ceph" \
  --build-arg GIT_REF="nautilus" \
  --tag myrepo/ceph-builder:bionic-nautilus \
  .
```

To add other package dependencies, a `EXTRA_PKGS` argument can also be 
provided, including the name of packages that need to be installed in 
addition to what `install-deps.sh` provides.
