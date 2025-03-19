# Xz Phase 4
XZ_VERSION=$((basename $PKG_XZ .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-$XZ_VERSION

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

	CC="gcc -m32" ./configure \
		--host=i686-pc-linux-gnu      \
		--prefix=/usr                 \
		--libdir=/usr/lib32           \
		--disable-static
	
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR

	#x32 bit
	make distclean

	CC="gcc -mx32" ./configure \
		--host=x86_64-pc-linux-gnux32 \
		--prefix=/usr                 \
		--libdir=/usr/libx32          \
		--disable-static
	
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi
