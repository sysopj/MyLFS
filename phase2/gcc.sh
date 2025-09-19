# GCC Phase 2
PKG_MPFR=$(basename $PKG_MPFR)
PKG_GMP=$(basename $PKG_GMP)
PKG_MPC=$(basename $PKG_MPC)

tar -xf ../$PKG_MPFR
mv ${PKG_MPFR%.tar*} mpfr

tar -xf ../$PKG_GMP
mv ${PKG_GMP%.tar*} gmp

tar -xf ../$PKG_MPC
mv ${PKG_MPC%.tar*} mpc

if [[ "$LFS_VERSION" == "11.1" ]];then
	case $(uname -m) in
	  x86_64)
		sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	  ;;
	esac

	mkdir build
	cd build

	mkdir -p $LFS_TGT/libgcc
	ln -s ../../../libgcc/gthr-posix.h $LFS_TGT/libgcc/gthr-default.h

	../configure                                       \
		--build=$(../config.guess)                     \
		--host=$LFS_TGT                                \
		--prefix=/usr                                  \
		CC_FOR_TARGET=$LFS_TGT-gcc                     \
		--with-build-sysroot=$LFS                      \
		--enable-initfini-array                        \
		--disable-nls                                  \
		--disable-multilib                             \
		--disable-decimal-float                        \
		--disable-libatomic                            \
		--disable-libgomp                              \
		--disable-libquadmath                          \
		--disable-libssp                               \
		--disable-libvtv                               \
		--disable-libstdcxx                            \
		--enable-languages=c,c++

	make
	make DESTDIR=$LFS install

	ln -s gcc $LFS/usr/bin/cc
fi

if [[ "$LFS_VERSION" == "11.2" ]];then
	case $(uname -m) in
	  x86_64)
		sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	  ;;
	esac

	sed '/thread_header =/s/@.*@/gthr-posix.h/' \
		-i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

	mkdir build
	cd build

	../configure                                       \
		--build=$(../config.guess)                     \
		--host=$LFS_TGT                                \
		--target=$LFS_TGT                              \
		LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
		--prefix=/usr                                  \
		--with-build-sysroot=$LFS                      \
		--enable-initfini-array                        \
		--disable-nls                                  \
		--disable-multilib                             \
		--disable-decimal-float                        \
		--disable-libatomic                            \
		--disable-libgomp                              \
		--disable-libquadmath                          \
		--disable-libssp                               \
		--disable-libvtv                               \
		--enable-languages=c,c++

	make
	make DESTDIR=$LFS install

	ln -s gcc $LFS/usr/bin/cc
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "false" ]];then
	case $(uname -m) in
	  x86_64)
		sed -e '/m64=/s/lib64/lib/' \
			-i.orig gcc/config/i386/t-linux64
	  ;;
	esac

	sed '/thread_header =/s/@.*@/gthr-posix.h/' \
		-i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

	mkdir build
	cd build

	../configure                                       \
		--build=$(../config.guess)                     \
		--host=$LFS_TGT                                \
		--target=$LFS_TGT                              \
		LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
		--prefix=/usr                                  \
		--with-build-sysroot=$LFS                      \
		--enable-default-pie                           \
		--enable-default-ssp                           \
		--disable-nls                                  \
		--disable-multilib                             \
		--disable-libatomic                            \
		--disable-libgomp                              \
		--disable-libquadmath                          \
		--disable-libsanitizer                         \
		--disable-libssp                               \
		--disable-libvtv                               \
		--enable-languages=c,c++

	make
	make DESTDIR=$LFS install

	ln -s gcc $LFS/usr/bin/cc

fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "true" ]];then
	case $(uname -m) in
	  x86_64)
		sed -e '/m64=/s/lib64/lib/' \
			-e '/m32=/s/m32=.*/m32=..\/lib32$(call if_multiarch,:i386-linux-gnu)/' \
			-i.orig gcc/config/i386/t-linux64
	  ;;
	esac

	sed '/thread_header =/s/@.*@/gthr-posix.h/' \
		-i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

	mkdir build
	cd build

	mlist=m64,m32,mx32
	../configure                                       \
		--build=$(../config.guess)                     \
		--host=$LFS_TGT                                \
		--target=$LFS_TGT                              \
		LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
		--prefix=/usr                                  \
		--with-build-sysroot=$LFS                      \
		--enable-default-pie                           \
		--enable-default-ssp                           \
		--disable-nls                                  \
		--enable-multilib --with-multilib-list=$mlist  \
		--disable-libatomic                            \
		--disable-libgomp                              \
		--disable-libquadmath                          \
		--disable-libsanitizer                         \
		--disable-libssp                               \
		--disable-libvtv                               \
		--enable-languages=c,c++

	make
	make DESTDIR=$LFS install

	ln -s gcc $LFS/usr/bin/cc

fi
