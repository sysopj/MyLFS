# LZ4 Phase 4

if [[ $PATCH_LZ4 ]]; then
	patch -Np1 -i ../$(basename $PATCH_LZ4)
fi

make BUILD_STATIC=no PREFIX=/usr

if $RUN_TESTS
then
    set +e
    make -j1 check
    set -e
fi

make BUILD_STATIC=no PREFIX=/usr install

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make clean

	CC="gcc -m32" make BUILD_STATIC=no
	
	make BUILD_STATIC=no PREFIX=/usr LIBDIR=/usr/lib32 DESTDIR=$(pwd)/m32 install &&
	cp -a m32/usr/lib32/* /usr/lib32/

	#x32 bit
	make clean

	CC="gcc -mx32" make BUILD_STATIC=no
	
	make BUILD_STATIC=no PREFIX=/usr LIBDIR=/usr/libx32 DESTDIR=$(pwd)/mx32 install &&
	cp -a mx32/usr/libx32/* /usr/libx32/
fi
