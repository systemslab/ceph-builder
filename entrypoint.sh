#!/bin/bash
set -e

if [ -z "$CEPH_SRC_DIR" ]; then
  echo "No CEPH_SRC_DIR variable defined, checking for ./ceph"

  if [ -d "./ceph"]; then
    echo "Found ./ceph, using it as source directory"
    CEPH_SRC_DIR="./ceph"
  elif [ -d "/ceph" ]; then
    echo "No folder in ./ceph found, attempting to use /ceph"
    CEPH_SRC_DIR="/ceph"
  fi
fi

if [ ! -d "$CEPH_SRC_DIR" ]; then
  echo "No folder in $CEPH_SRC_DIR"
  exit 1
fi

cd "$CEPH_SRC_DIR"

if [ "$CMAKE_CLEAN" == "true" ]; then
  rm -rf ./build
fi

mkdir -p ./build

cd build/

if [ -z "$(ls -A ./)" ] || [ "$CMAKE_RECONFIGURE" == "true" ] ; then
  cmake $CMAKE_FLAGS ..
fi

if [ -z "$BUILD_THREADS" ] ; then
  BUILD_THREADS=`grep processor /proc/cpuinfo | wc -l`
fi

make -j$BUILD_THREADS $@
