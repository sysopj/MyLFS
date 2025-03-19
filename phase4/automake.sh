# Automake Phase 4
AUTOMAKE_VERSION=$((basename $PKG_AUTOMAKE .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr --docdir=/usr/share/doc/automake-$AUTOMAKE_VERSION

make

if $RUN_TESTS
then
    set +e
    make -j$(($(nproc)>4?$(nproc):4)) check
    set -e
fi

make install

