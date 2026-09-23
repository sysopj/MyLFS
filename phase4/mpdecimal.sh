# mpdecimal Phase 4
VERSION=$(basename $PKG_MPDECIMAL .tar.gz | cut -d "-" -f2)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpdecimal-$VERSION

make

if $RUN_TESTS
then
    set +e
    make check_local
    set -e
fi

make install
