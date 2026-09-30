#!/bin/sh
set -eu

# Use the system FLINT 3 / MPFR / GMP libraries instead of building FLINT 2.8.
# The pinned Normaliz sources and OCaml bindings remain unchanged.
cd Normaliz-offline
./bootstrap.sh
normaliz_prefix="$PWD/local"
mkdir -p build
cd build
../configure --prefix="$normaliz_prefix" --with-flint=yes \
  --without-nauty --without-cocoalib CPPFLAGS=-fPIC
make -j "$1"
make install
