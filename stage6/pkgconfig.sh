#!/usr/bin/env bash
# Pkg-config Stage 6
# ~~~~~~~~~~~~~~~~~~
set -e

cd /sources

eval "$(grep PKGCONFIG $PACKAGE_LIST)"
PKG_PKGCONFIG=$(basename $PKG_PKGCONFIG)

tar -xf $PKG_PKGCONFIG
cd ${PKG_PKGCONFIG%.tar*}

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2

make

make check

make install

cd /sources
rm -rf ${PKG_PKGCONFIG%.tar*}

