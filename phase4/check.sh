# Check Phase 4
CHECK_VERSION=$((basename $PKG_CHECK .tar.gz) | cut -d "-" -f 2)

./configure --prefix=/usr --disable-static

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make docdir=/usr/share/doc/check-$CHECK_VERSION install
