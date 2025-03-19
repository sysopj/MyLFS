# Kmod Phase 4
if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr          \
				--sysconfdir=/etc      \
				--with-openssl         \
				--with-xz              \
				--with-zstd            \
				--with-zlib
				
	make

	make install
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	./configure --prefix=/usr     \
				--sysconfdir=/etc \
				--with-openssl    \
				--with-xz         \
				--with-zstd       \
				--with-zlib       \
				--disable-manpages

	make

	make install
fi

if [[ "$LFS_VERSION" == "12.3" ]]; then
	mkdir -p build
	cd       build

	meson setup --prefix=/usr ..    \
            --sbindir=/usr/sbin \
            --buildtype=release \
            -D manpages=false
	
	ninja
	
	ninja install
fi



if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	for target in depmod insmod modinfo modprobe rmmod; do
	  ln -sf ../bin/kmod /usr/sbin/$target
	done
	
	ln -sf kmod /usr/bin/lsmod
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	for target in depmod insmod modinfo modprobe rmmod; do
	  ln -sf ../bin/kmod /usr/sbin/$target
	  rm -fv /usr/bin/$target
	done
fi

if [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	sed -e "s/^CLEANFILES =.*/CLEANFILES =/" -i man/Makefile
	make clean

	CC="gcc -m32" ./configure \
		--host=i686-pc-linux-gnu      \
		--prefix=/usr                 \
		--libdir=/usr/lib32           \
		--sysconfdir=/etc             \
		--with-openssl                \
		--with-xz                     \
		--with-zstd                   \
		--with-zlib                   \
		--disable-manpages            \
		--with-rootlibdir=/usr/lib32

	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR	
	
	#x32bit
	sed -e "s/^CLEANFILES =.*/CLEANFILES =/" -i man/Makefile
	make clean

	CC="gcc -mx32" ./configure \
		--host=x86_64-pc-linux-gnux32 \
		--prefix=/usr                 \
		--libdir=/usr/libx32          \
		--sysconfdir=/etc             \
		--with-openssl                \
		--with-xz                     \
		--with-zstd                   \
		--with-zlib                   \
		--disable-manpages            \
		--with-rootlibdir=/usr/libx32

	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi

if [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]]; then
	#x32 bit
	cd .. &&
	rm -rf build &&
	mkdir build &&
	cd build

	PKG_CONFIG_PATH="/usr/lib32/pkgconfig" \
	CC="gcc -m32 -march=i686"              \
	CXX="g++ -m32 -march=i686"             \
	meson setup --prefix=/usr ..    \
				--sbindir=/usr/sbin \
				--buildtype=release \
				--libdir=/usr/lib32 \
				-D manpages=false

	ninja

	DESTDIR=$PWD/DESTDIR ninja install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
	
	#32 bit
	cd .. &&
	rm -rf build &&
	mkdir build &&
	cd build

	PKG_CONFIG_PATH="/usr/libx32/pkgconfig" \
	CC="gcc -mx32"                          \
	CXX="g++ -mx32"                         \
	meson setup --prefix=/usr ..    \
				--sbindir=/usr/sbin \
				--buildtype=release \
				--libdir=/usr/libx32 \
				-D manpages=false

	ninja

	DESTDIR=$PWD/DESTDIR ninja install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi
