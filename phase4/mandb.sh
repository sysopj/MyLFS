# Man-DB Phase 4
MANDB_VERSION=$((basename $PKG_MANDB .tar.xz) | cut -d "-" -f 3)

if [[ "$LFS_VERSION" == "12.2" ]]; then
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-$MANDB_VERSION \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
fi

if [[ "$LFS_VERSION" == "12.3" ]]; then
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-$MANDB_VERSION \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap
fi

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

