# Bison Phase 3
BISON_VERSION=$((basename $PKG_BISON .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-$BISON_VERSION

make
make install

