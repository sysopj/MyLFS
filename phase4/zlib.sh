# Zlib Phase 4
./configure --prefix=/usr

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

rm -f /usr/lib/libz.a

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

	CFLAGS+=" -m32" CXXFLAGS+=" -m32" \
	./configure --prefix=/usr \
		--libdir=/usr/lib32
		
	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
	
	#x32 bit
	make distclean

	CFLAGS+=" -mx32" CXXFLAGS+=" -mx32" \
	./configure --prefix=/usr    \
		--libdir=/usr/libx32

	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi