# Elfutils Phase 4
./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make -C libelf install
install -m644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

	CC="gcc -m32" CXX="g++ -m32" ./configure \
		--host=i686-pc-linux-gnu \
		--prefix=/usr            \
		--libdir=/usr/lib32      \
		--disable-debuginfod     \
		--enable-libdebuginfod=dummy

	make

	make DESTDIR=$PWD/DESTDIR -C libelf install
	install -vDm644 config/libelf.pc DESTDIR/usr/lib32/pkgconfig/libelf.pc
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
	
	#x32bit
	make distclean

	CC="gcc -mx32" CXX="g++ -mx32" ./configure \
		--host=x86_64-pc-linux-gnux32 \
		--prefix=/usr                 \
		--libdir=/usr/libx32          \
		--disable-debuginfod          \
		--enable-libdebuginfod=dummy

	make

	make DESTDIR=$PWD/DESTDIR -C libelf install
	install -vDm644 config/libelf.pc DESTDIR/usr/libx32/pkgconfig/libelf.pc
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi