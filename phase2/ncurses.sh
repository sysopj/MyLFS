# ncurses Phase 2

if [[ "$LFS_VERSION" == "11.1" ]]  && [[ "$MULTILIB" == "false" ]];then
	sed -i s/mawk// configure

	mkdir build
	pushd build
	../configure
	make -C include
	make -C progs tic
	popd

	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--without-debug              \
				--without-ada                \
				--disable-stripping          \
				--enable-widec

	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so
fi

if [[ "$LFS_VERSION" == "11.2" ]]  && [[ "$MULTILIB" == "false" ]];then
	sed -i s/mawk// configure

	mkdir build
	pushd build
	../configure
	make -C include
	make -C progs tic
	popd

	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--with-cxx-shared            \
				--without-debug              \
				--without-ada                \
				--disable-stripping          \
				--enable-widec

	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "false" ]];then
	#sed -i s/mawk// configure
	
	mkdir build
	pushd build
		../configure AWK=gawk
		make -C include
		make -C progs tic
	popd

	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--with-cxx-shared            \
				--without-debug              \
				--without-ada                \
				--disable-stripping          \
				AWK=gawk

	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i $LFS/usr/include/curses.h
fi

if [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "false" ]];then
	#sed -i s/mawk// configure
	
	mkdir build
	pushd build
		../configure --prefix=$LFS/tools AWK=gawk
		make -C include
		make -C progs tic
		install progs/tic $LFS/tools/bin
	popd

	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--with-cxx-shared            \
				--without-debug              \
				--without-ada                \
				--disable-stripping          \
				AWK=gawk

	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i $LFS/usr/include/curses.h
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]];then
	#64 bit
	mkdir build
	pushd build
		../configure AWK=gawk
		make -C include
		make -C progs tic
	popd

	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--with-cxx-shared            \
				--without-debug              \
				--without-ada                \
				--disable-stripping          \
				AWK=gawk

	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	[ -f $LFS/usr/lib/libncurses.so ] && unlink $LFS/usr/lib/libncurses.so
	ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i $LFS/usr/include/curses.h

	#32 bit
	make distclean
	
	CC="$LFS_TGT-gcc -m32"              \
	CXX="$LFS_TGT-g++ -m32"             \
	./configure --prefix=/usr           \
				--host=$LFS_TGT32       \
				--build=$(./config.guess)    \
				--libdir=/usr/lib32     \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-normal        \
				--with-cxx-shared       \
				--without-debug         \
				--without-ada           \
				--disable-stripping
	
	make
	
	make DESTDIR=$PWD/DESTDIR TIC_PATH=$(pwd)/build/progs/tic install
	[ -f DESTDIR/usr/lib32/libncurses.so ] && unlink DESTDIR/usr/lib32/libncurses.so
	ln -sv libncursesw.so DESTDIR/usr/lib32/libncurses.so
	cp -Rv DESTDIR/usr/lib32/* $LFS/usr/lib32
	rm -rf DESTDIR
	
	#x32 bit
	make distclean
	
	CC="$LFS_TGT-gcc -mx32"              \
	CXX="$LFS_TGT-g++ -mx32"             \
	./configure --prefix=/usr           \
				--host=$LFS_TGTX32       \
				--build=$(./config.guess)    \
				--libdir=/usr/libx32     \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-normal        \
				--with-cxx-shared       \
				--without-debug         \
				--without-ada           \
				--disable-stripping
	
	make
	
	make DESTDIR=$PWD/DESTDIR TIC_PATH=$(pwd)/build/progs/tic install
	[ -f DESTDIR/usr/libx32/libncurses.so ] && unlink DESTDIR/usr/libx32/libncurses.so
	ln -sv libncursesw.so DESTDIR/usr/libx32/libncurses.so
	cp -Rv DESTDIR/usr/libx32/* $LFS/usr/libx32
	rm -rf DESTDIR
fi

if [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "true" ]];then
	#64 bit
	mkdir build
	pushd build
		../configure --prefix=$LFS/tools AWK=gawk
		make -C include
		make -C progs tic
		install progs/tic $LFS/tools/bin
	popd

	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--with-cxx-shared            \
				--without-debug              \
				--without-ada                \
				--disable-stripping          \
				AWK=gawk

	make
	make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
	[ -f $LFS/usr/lib/libncurses.so ] && unlink $LFS/usr/lib/libncurses.so
	ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i $LFS/usr/include/curses.h

	#32 bit
	make distclean
	
	CC="$LFS_TGT-gcc -m32"              \
	CXX="$LFS_TGT-g++ -m32"             \
	./configure --prefix=/usr           \
				--host=$LFS_TGT32       \
				--build=$(./config.guess)    \
				--libdir=/usr/lib32     \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-normal        \
				--with-cxx-shared       \
				--without-debug         \
				--without-ada           \
				--disable-stripping
	
	make
	
	make DESTDIR=$PWD/DESTDIR TIC_PATH=$(pwd)/build/progs/tic install
	[ -f DESTDIR/usr/lib32/libncurses.so ] && unlink DESTDIR/usr/lib32/libncurses.so
	ln -sv libncursesw.so DESTDIR/usr/lib32/libncurses.so
	cp -Rv DESTDIR/usr/lib32/* $LFS/usr/lib32
	rm -rf DESTDIR
	
	#x32 bit
	make distclean
	
	CC="$LFS_TGT-gcc -mx32"              \
	CXX="$LFS_TGT-g++ -mx32"             \
	./configure --prefix=/usr           \
				--host=$LFS_TGTX32       \
				--build=$(./config.guess)    \
				--libdir=/usr/libx32     \
				--mandir=/usr/share/man \
				--with-shared           \
				--without-normal        \
				--with-cxx-shared       \
				--without-debug         \
				--without-ada           \
				--disable-stripping
	
	make
	
	make DESTDIR=$PWD/DESTDIR TIC_PATH=$(pwd)/build/progs/tic install
	[ -f DESTDIR/usr/libx32/libncurses.so ] && unlink DESTDIR/usr/libx32/libncurses.so
	ln -sv libncursesw.so DESTDIR/usr/libx32/libncurses.so
	cp -Rv DESTDIR/usr/libx32/* $LFS/usr/libx32
	rm -rf DESTDIR
fi
