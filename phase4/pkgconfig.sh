# Pkg-config Phase 4
PKGCONFIG_VERSION=$((basename $PKG_PKGCONFIG .tar.xz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-$PKGCONFIG_VERSION
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
./configure --prefix=/usr              \
            --with-internal-glib       \
            --docdir=/usr/share/doc/pkgconfig-$PKGCONFIG_VERSION
fi

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	ln -sv pkgconf   /usr/bin/pkg-config
	ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1
fi
