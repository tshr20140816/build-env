#!/bin/bash

set -x

date

PARALLEL_VERSION=20191022

export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fuse-ld=gold"

export CCACHE_DIR=/tmp/ccache_cache

export PATH="/tmp/usr/bin:${PATH}"

# pushd /tmp/usr/bin
# ln -s ccache gcc
# ln -s ccache g++
# ln -s ccache cc
# ln -s ccache c++
# popd

ccache --version

# ccache -s
# ccache -z

pushd /tmp

curl -O http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
tar xf parallel-latest.tar.bz2
ls -lang
pushd parallel-${PARALLEL_VERSION}
./configure --help
time ./configure --prefix=/tmp/usr

time timeout -sKILL 210 make -j$(grep -c -e processor /proc/cpuinfo)
time make install
popd
popd

tree /tmp/usr

ldd /tmp/usr/bin/parallel

/tmp/usr/bin/parallel --version

cp /tmp/usr/bin/parallel ../www/

date
