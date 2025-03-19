# Kbd Phase 4
KBD_VERSION=$((basename $PKG_KBD .tar.xz) | cut -d "-" -f 2)

if [ -f ../$(basename $PATCH_KBD) ]; then
	patch -Np1 -i ../$(basename $PATCH_KBD)
fi

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

mkdir -p           /usr/share/doc/kbd-$KBD_VERSION
cp -R docs/doc/* /usr/share/doc/kbd-$KBD_VERSION

