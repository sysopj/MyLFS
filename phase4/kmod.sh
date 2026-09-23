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

if [[ "$LFS_VERSION" == "12.4" ]] || [[ "$LFS_VERSION" == "13.0" ]] || [[ "$LFS_VERSION" == "13.1" ]]; then
	mkdir -p build
	cd       build

	meson setup --prefix=/usr ..    \
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
fi
if [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "true" ]] && [[ "$MULTILIB_mx32" == "true" ]]; then	
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
	#32 bit
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
fi
if [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]] && [[ "$MULTILIB_mx32" == "true" ]]; then	
	#x32 bit
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

if [[ "$LFS_VERSION" == "12.4" ]] || [[ "$LFS_VERSION" == "13.0" ]] || [[ "$LFS_VERSION" == "13.1" ]] && [[ "$MULTILIB" == "true" ]]; then
	#32 bit
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
fi
if [[ "$LFS_VERSION" == "12.4" ]] || [[ "$LFS_VERSION" == "13.0" ]] || [[ "$LFS_VERSION" == "13.1" ]] && [[ "$MULTILIB" == "true" ]] && [[ "$MULTILIB_mx32" == "true" ]]; then	
	#x32 bit
	cd .. &&
	rm -rf build &&
	mkdir build &&
	cd build

	# Make a cross compile file or add syscall.x32=y to kernel commands
cat > x32-cross.ini << "EOF"
[binaries]
c = 'gcc'
cpp = 'g++'
ar = 'ar'
strip = 'strip'
pkgconfig = 'pkg-config'

[built-in options]
c_args = ['-mx32', '-march=x86-64']
c_link_args = ['-mx32']
cpp_args = ['-mx32', '-march=x86-64']
cpp_link_args = ['-mx32']

[properties]
# This tells Meson the compiled binaries cannot be run natively
needs_exe_wrapper = true

[host_machine]
system = 'linux'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
EOF

	PKG_CONFIG_PATH="/usr/libx32/pkgconfig" \
	CC="gcc -mx32 -march=x86-64"                          \
	CXX="g++ -mx32 -march=x86-64"                         \
	BUILD_CC="gcc"							\
	BUILD_CXX="g++"							\
	meson setup --cross-file x32-cross.ini \
				--prefix=/usr ..    \
				--buildtype=release \
				--libdir=/usr/libx32 \
				-D manpages=false

	ninja

	DESTDIR=$PWD/DESTDIR ninja install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi
