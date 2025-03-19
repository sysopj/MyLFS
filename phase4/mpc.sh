# MPC Phase 4
MPC_VERSION=$((basename $PKG_MPC .tar.gz) | cut -d "-" -f 2)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-$MPC_VERSION

make
make html

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install
make install-html

