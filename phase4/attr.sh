# Attr Phase 4
ATTR_VERSION=$((basename $PKG_ATTR .tar.gz) | cut -d "-" -f 2)

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-$ATTR_VERSION

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
		--prefix=/usr         \
		--disable-static      \
		--sysconfdir=/etc     \
		--libdir=/usr/lib32   \
		--host=i686-pc-linux-gnu
		
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
	
	#x32bit
	make distclean
	
	CC="gcc -mx32" ./configure \
		--prefix=/usr          \
		--disable-static       \
		--sysconfdir=/etc      \
		--libdir=/usr/libx32   \
		--host=x86_64-pc-linux-gnux32
		
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR	
fi