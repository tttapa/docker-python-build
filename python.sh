#!/usr/bin/env bash

# Script to download and build Python 3 from source

set -ex

version="${1:-3.10}"
prefix="${2:-/usr/local}"
builddir="/tmp"
opts="--with-lto --enable-optimizations"

case $version in 
  3.7)
    full_version=3.7.13
    python="Python-$full_version"
    opts="--with-lto";;
  3.8)
    full_version=3.8.13
    python="Python-$full_version";;
  3.9)
    full_version=3.9.13
    python="Python-$full_version";;
  3.10)
    full_version=3.10.6
    python="Python-${full_version}";;
  3.11)
    full_version=3.11.0
    python="Python-${full_version}rc1";;
esac

# Download and extract the Python source code
mkdir -p "$builddir"
pushd "$builddir"
if [ ! -d "$python" ]; then
    wget -O- "https://www.python.org/ftp/python/$full_version/$python.tgz" | tar -xz
fi

pushd "$python"
./configure --prefix="$prefix" \
    --enable-ipv6 \
    --enable-shared \
    $opts \
    'LDFLAGS=-Wl,-rpath,\$$ORIGIN/../lib'

make -j$(($(nproc) + 2))
# make altinstall
make install

popd
popd
rm -rf "$builddir"
