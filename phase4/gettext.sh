# Gettext Phase 4
GETTEXT_VERSION=$((basename $PKG_GETTEXT .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-$GETTEXT_VERSION

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install
chmod 0755 /usr/lib/preloadable_libintl.so

