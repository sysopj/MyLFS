# Tar Phase 4
TAR_VERSION=$((basename $PKG_TAR .tar.xz) | cut -d "-" -f 2)

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make

if $RUN_TESTS
then
    set +e
    make check 
    set -e
fi

make install

make -C doc install-html docdir=/usr/share/doc/tar-$TAR_VERSION

