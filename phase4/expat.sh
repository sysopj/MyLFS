# Expat Phase 4
EXPAT_VERSION=$((basename $PKG_EXPAT .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-$EXPAT_VERSION

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

install -m644 doc/*.{html,css} /usr/share/doc/expat-$EXPAT_VERSION

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	sed -e "/^am__append_1/ s/doc//" -i Makefile
	make clean

	CC="gcc -m32" ./configure \
		--prefix=/usr        \
		--disable-static     \
		--libdir=/usr/lib32  \
		--host=i686-pc-linux-gnu
	
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
	
	#x32bit
	sed -e "/^am__append_1/ s/doc//" -i Makefile
	make clean

	CC="gcc -mx32" ./configure \
		--prefix=/usr        \
		--disable-static     \
		--libdir=/usr/libx32 \
		--host=x86_64-pc-linux-gnux32
	
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR	
fi