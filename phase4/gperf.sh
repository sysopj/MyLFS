# Gperf Phase 4
GPERF_VERSION=$((basename $PKG_GPERF .tar.gz) | cut -d "-" -f 2)

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-$GPERF_VERSION

make

if $RUN_TESTS
then
    set +e
    make -j1 check
    set -e
fi

make install

