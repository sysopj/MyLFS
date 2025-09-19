# Zstd Phase 4
if [[ $PATCH_ZSTD ]]; then
	patch -Np1 -i ../$(basename $PATCH_ZSTD)
fi

if [[ "$LFS_VERSION" == "11.1" ]]; then
	make
fi

if [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "11.3" ]] || [[ "$LFS_VERSION" == "12.0" ]] || [[ "$LFS_VERSION" == "12.1" ]] || [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	make prefix=/usr
fi

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make prefix=/usr install
rm /usr/lib/libzstd.a

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make clean

	CC="gcc -m32" make prefix=/usr
	
	make prefix=/usr DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib/* /usr/lib32/
	sed -e "/^libdir/s/lib$/lib32/" -i /usr/lib32/pkgconfig/libzstd.pc
	rm -rf DESTDIR

	#x32 bit
	make clean

	CC="gcc -mx32" make prefix=/usr
	
	make prefix=/usr DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib/* /usr/libx32/
	sed -e "/^libdir/s/lib$/libx32/" -i /usr/libx32/pkgconfig/libzstd.pc
	rm -rf DESTDIR
fi
