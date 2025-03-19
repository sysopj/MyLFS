# Acl Phase 4
ACL_VERSION=$((basename $PKG_ACL .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-$ACL_VERSION

make

make install

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean
	
	CC="gcc -m32" ./configure \
		--prefix=/usr         \
		--disable-static      \
		--libdir=/usr/lib32   \
		--libexecdir=/usr/lib32   \
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
		--libdir=/usr/libx32   \
		--libexecdir=/usr/libx32   \
		--host=x86_64-pc-linux-gnux32
		
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR	
fi