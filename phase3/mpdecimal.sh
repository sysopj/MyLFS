# mpdecimal Phase 3
VERSION=$(basename $PKG_MPDECIMAL .tar.gz | cut -d "-" -f2)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpdecimal-$VERSION

make

make install
