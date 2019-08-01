# Docker Images for Building Ceph

Docker images containing build dependencies for Ceph. Why? To speedup 
Ceph development workflows. To build an image:

```bash
docker build \
  --build-arg UBUNTU_VERSION="bionic" \
  --build-arg GITHUB_REPO="ceph/ceph" \
  --build-arg GIT_REF="nautilus" \
  --tag myrepo/ceph-builder:bionic-nautilus \
  .
```

To add other package dependencies, a `INSTALL_SCRIPT` argument can 
also be provided, pointing to a file available in the Docker build 
context that is invoked when the image is built. For example, to 
install custom packages, create a file in this folder (e.g. 
`mydeps.sh`), and pass the `--build-arg INSTALL_SCRIPT=mydeps.sh` 
script.
