#!/bin/bash
set -e

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
