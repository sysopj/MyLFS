# MPFR Phase 4
MPFR_VERSION=$((basename $PKG_MPFR .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-$MPFR_VERSION

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

