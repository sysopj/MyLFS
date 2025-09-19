# Libffi Phase 4
if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr          \
				--disable-static       \
				--with-gcc-arch=native \
				--disable-exec-static-tramp
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	./configure --prefix=/usr          \
				--disable-static       \
				--with-gcc-arch=native
fi

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

	CC="gcc -m32" CXX="g++ -m32" ./configure \
		--host=i686-pc-linux-gnu \
		--prefix=/usr            \
		--libdir=/usr/lib32      \
		--disable-static         \
		--with-gcc-arch=i686

	make

	if $RUN_TESTS
	then
		set +e
		make check
		set -e
	fi

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
	
	#x32bit
	make distclean

	CC="gcc -mx32" CXX="g++ -mx32" ./configure \
		--host=x86_64-unknown-linux-gnux32 \
		--prefix=/usr            \
		--libdir=/usr/libx32     \
		--disable-static         \
		--with-gcc-arch=x86_64

	make

	if $RUN_TESTS
	then
		set +e
		make check
		set -e
	fi


	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi