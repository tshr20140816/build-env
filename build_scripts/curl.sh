#!/bin/bash

set -x

date

CURL_VERSION=7.66.0

export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fuse-ld=gold"

export CCACHE_DIR=/tmp/ccache

export PATH="/tmp/usr/bin:${PATH}"

pushd /tmp/usr/bin
ln -s ccache gcc
ln -s ccache g++
ln -s ccache cc
ln -s ccache c++
popd

ccache -s
ccache -z

pushd /tmp

time git clone --depth=1 -b release-0.1.3 https://github.com/metalink-dev/libmetalink.git
pushd libmetalink
time ./buildconf
./configure --help
time ./configure --prefix=/tmp/usr --enable-shared=no
time make -j2
make install
popd

curl -O https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.xz
tar xf curl-${CURL_VERSION}.tar.xz
pushd curl-${CURL_VERSION}
./configure --help
./configure --prefix=/tmp/usr --enable-shared=no --enable-static=yes \
  --with-libssh2 --with-brotli --with-nghttp2 \
  --with-gssapi --with-libmetalink=/tmp/usr --enable-alt-svc

time timeout -sKILL 210 make -j$(grep -c -e processor /proc/cpuinfo)
if [ $? != 0 ]; then
  echo 'time out'
  result='NG'
else
  result='OK'
  time make install
fi
popd
popd

ccache -s

pushd /tmp
time tar cf ccache_cache.tar.bz2 --use-compress-prog=pbzip2 ./ccache
mv ccache_cache.tar.bz2 repo/build-env/ccache/
pushd repo/build-env
git init
git config --global user.email "user"
git config --global user.name "user"
git add .
git commit -a -m "."
git remote set-url origin https://github.com/tshr20140816/build-env
git push origin master
popd
popd

tree /tmp/usr

ldd /tmp/usr/bin/curl

/tmp/usr/bin/curl --version

pushd ../
cp /tmp/usr/bin/curl ./www/
popd

date