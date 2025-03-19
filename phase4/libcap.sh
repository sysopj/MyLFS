# Libcap Phase 4
LIBCAP_VERSION=$((basename $PKG_LIBCAP .tar.xz) | cut -d "-" -f 2)

sed -i '/install -m.*STA/d' libcap/Makefile
make prefix=/usr lib=lib

if $RUN_TESTS
then
    set +e
    make test
    set -e
fi

make prefix=/usr lib=lib install

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean
	
	make CC="gcc -m32 -march=i686"
	
	make CC="gcc -m32 -march=i686" lib=lib32 prefix=$PWD/DESTDIR/usr -C libcap install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	sed -e "s|^libdir=.*|libdir=/usr/lib32|" -i /usr/lib32/pkgconfig/lib{cap,psx}.pc
	chmod -v 755 /usr/lib32/libcap.so.$LIBCAP_VERSION
	rm -rf DESTDIR
	
	#x32bit
	make distclean
	
	make CC="gcc -mx32 -march=x86-64"
	
	make CC="gcc -mx32 -march=x86-64" lib=libx32 prefix=$PWD/DESTDIR/usr -C libcap install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	sed -e "s|^libdir=.*|libdir=/usr/libx32|" -i /usr/libx32/pkgconfig/lib{cap,psx}.pc
	chmod -v 755 /usr/libx32/libcap.so.$LIBCAP_VERSION
	rm -rf DESTDIR
fi