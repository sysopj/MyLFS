# Ncurses Phase 4
NCURSES_VERSION=$((basename $PKG_NCURSES .tar.gz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr           \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-debug         \
				--without-normal        \
				--enable-pc-files       \
				--enable-widec          \
				--with-pkg-config-libdir=/usr/lib/pkgconfig
fi

if [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr           \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-debug         \
				--without-normal        \
				--with-cxx-shared       \
				--enable-pc-files       \
				--enable-widec          \
				--with-pkg-config-libdir=/usr/lib/pkgconfig
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	./configure --prefix=/usr           \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-debug         \
				--without-normal        \
				--with-cxx-shared       \
				--enable-pc-files       \
				--with-pkg-config-libdir=/usr/lib/pkgconfig
fi

make

make DESTDIR=$PWD/dest install
install -m755 dest/usr/lib/libncursesw.so.$NCURSES_VERSION /usr/lib
rm dest/usr/lib/libncursesw.so.$NCURSES_VERSION

if [[ "$LFS_VERSION" == "11.2" ]]; then
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i dest/usr/include/curses.h
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i dest/usr/include/curses.h
fi

cp -a dest/* /

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	for lib in ncurses form panel menu ; do
		rm -f                    /usr/lib/lib${lib}.so
		echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
		ln -sf ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
	done
	
	rm -f                     /usr/lib/libcursesw.so
	echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	for lib in ncurses form panel menu ; do
		ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
		ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
	done
fi

ln -sf libncurses.so      /usr/lib/libcurses.so

mkdir -p      /usr/share/doc/ncurses-$NCURSES_VERSION
cp -R doc/* /usr/share/doc/ncurses-$NCURSES_VERSION

if [[ "$LFS_VERSION" == "11.2" ]]; then
	make distclean
	./configure --prefix=/usr    \
				--with-shared    \
				--without-normal \
				--without-debug  \
				--without-cxx-binding \
				--with-abi-version=5
	make sources libs
	cp -av lib/lib*.so.5* /usr/lib
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	make distclean
	./configure --prefix=/usr     \
				--with-shared     \
				--without-normal  \
				--with-cxx-shared \
				--without-debug   \
				--without-cxx-binding \
				--with-abi-version=5
	make sources libs
	cp -av lib/lib*.so.5* /usr/lib
fi

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

	CC="gcc -m32" CXX="g++ -m32" \
	./configure --prefix=/usr           \
				--host=i686-pc-linux-gnu \
				--libdir=/usr/lib32     \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-debug         \
				--without-normal        \
				--with-cxx-shared       \
				--enable-pc-files       \
				--with-pkg-config-libdir=/usr/lib32/pkgconfig

	make

	make DESTDIR=$PWD/DESTDIR install
	mkdir -p DESTDIR/usr/lib32/pkgconfig
	for lib in ncurses form panel menu ; do
		rm -vf                    DESTDIR/usr/lib32/lib${lib}.so
		echo "INPUT(-l${lib}w)" > DESTDIR/usr/lib32/lib${lib}.so
		ln -svf ${lib}w.pc        DESTDIR/usr/lib32/pkgconfig/$lib.pc
	done
	rm -vf                     DESTDIR/usr/lib32/libcursesw.so
	echo "INPUT(-lncursesw)" > DESTDIR/usr/lib32/libcursesw.so
	ln -sfv libncurses.so      DESTDIR/usr/lib32/libcurses.so
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR		
	
	#x32bit
	make distclean

	CC="gcc -mx32" CXX="g++ -mx32" \
	./configure --prefix=/usr           \
				--host=x86_64-pc-linux-gnux32 \
				--libdir=/usr/libx32    \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-debug         \
				--without-normal        \
				--enable-pc-files       \
				--with-pkg-config-libdir=/usr/libx32/pkgconfig

	make

	make DESTDIR=$PWD/DESTDIR install
	mkdir -p DESTDIR/usr/libx32/pkgconfig
	for lib in ncurses form panel menu ; do
		rm -vf                    DESTDIR/usr/libx32/lib${lib}.so
		echo "INPUT(-l${lib}w)" > DESTDIR/usr/libx32/lib${lib}.so
		ln -svf ${lib}w.pc        DESTDIR/usr/libx32/pkgconfig/$lib.pc
	done
	rm -vf                     DESTDIR/usr/libx32/libcursesw.so
	echo "INPUT(-lncursesw)" > DESTDIR/usr/libx32/libcursesw.so
	ln -sfv libncurses.so      DESTDIR/usr/libx32/libcurses.so
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi