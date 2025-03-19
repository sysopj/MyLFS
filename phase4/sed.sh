# Sed Phase 4
SED_VERSION=$((basename $PKG_SED .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr

make
make html

if $RUN_TESTS
then
    set +e
    chown -R tester .
    su tester -c "PATH=$PATH make check"
    set -e
fi

make install
install -d -m755 /usr/share/doc/sed-$SED_VERSION
install -m644 doc/sed.html /usr/share/doc/sed-$SED_VERSION

