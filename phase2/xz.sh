# Xz Phase 2
XZ_VERSION=$((basename $PKG_XZ .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-$XZ_VERSION

make
make DESTDIR=$LFS install

rm $LFS/usr/lib/liblzma.la

