# Readline Phase 4
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]];then
	sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
fi

READLINE_VERSION=$((basename $PKG_READLINE .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-$READLINE_VERSION

make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install

install -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-$READLINE_VERSION

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

	CC="gcc -m32" ./configure \
		--host=i686-pc-linux-gnu      \
		--prefix=/usr                 \
		--libdir=/usr/lib32           \
		--disable-static              \
		--with-curses
	
	make SHLIB_LIBS="-lncursesw"
	
	make SHLIB_LIBS="-lncursesw" DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR

	#x32 bit
	make distclean

	CC="gcc -mx32" ./configure \
		--host=x86_64-pc-linux-gnux32 \
		--prefix=/usr                 \
		--libdir=/usr/libx32          \
		--disable-static              \
		--with-curses
	
	make SHLIB_LIBS="-lncursesw"
	
	make SHLIB_LIBS="-lncursesw" DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi
