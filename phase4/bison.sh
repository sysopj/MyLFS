# Bison Phase 4
BISON_VERSION=$((basename $PKG_BISON .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr --docdir=/usr/share/doc/bison-$BISON_VERSION

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

