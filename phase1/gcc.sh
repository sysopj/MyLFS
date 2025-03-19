# GCC Phase 1
PKG_MPFR=$(basename $PKG_MPFR)
PKG_GMP=$(basename $PKG_GMP)
PKG_MPC=$(basename $PKG_MPC)

tar -xf ../$PKG_MPFR
mv ${PKG_MPFR%.tar*} mpfr

tar -xf ../$PKG_GMP
mv ${PKG_GMP%.tar*} gmp

tar -xf ../$PKG_MPC
mv ${PKG_MPC%.tar*} mpc

if [[ "$MULTILIB" == "false" ]]; then
	case $(uname -m) in
		x86_64)
			sed -e '/m64=/s/lib64/lib/' \
				-i.orig gcc/config/i386/t-linux64	
		;;
	esac
else
	sed -e '/m64=/s/lib64/lib/' -e '/m32=/s/m32=.*/m32=..\/lib32$(call if_multiarch,:i386-linux-gnu)/' -i.orig gcc/config/i386/t-linux64
fi


mkdir build
cd build

GLIBC_VERSION=$((basename $PKG_GLIBC .tar.xz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "10.0" ]] || [[ "$LFS_VERSION" == "10.1" ]] || [[ "$LFS_VERSION" == "11.0" ]] || [[ "$LFS_VERSION" == "11.1" ]];then
../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=$GLIBC_VERSION            \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
	--enable-initfini-array                        \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
fi

if [[ "$LFS_VERSION" == "11.2" ]];then
../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=$GLIBC_VERSION            \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
fi

if [[ "$LFS_VERSION" == "11.3" ]] || [[ "$LFS_VERSION" == "12.0" ]] || [[ "$LFS_VERSION" == "12.1" ]] && [[ "$MULTILIB" == "false" ]]; then
	
../configure                  \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=$GLIBC_VERSION            \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --enable-default-pie                           \
    --enable-default-ssp                           \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "false" ]]; then
	
	../configure							\
		--target=$LFS_TGT					\
		--prefix=$LFS/tools				 	\
		--with-glibc-version=$GLIBC_VERSION \
		--with-sysroot=$LFS     			\
		--with-newlib           			\
		--without-headers					\
		--enable-default-pie				\
		--enable-default-ssp				\
		--disable-nls						\
		--disable-shared					\
		--disable-multilib					\
		--disable-threads					\
		--disable-libatomic					\
		--disable-libgomp					\
		--disable-libquadmath				\
		--disable-libssp					\
		--disable-libvtv					\
		--disable-libstdcxx					\
		--enable-languages=c,c++			\
		--disable-bootstrap
	# --disable-bootstrap is needed for a stage one with matching LFS_TGT with the host is x86_64-linux-gnu

fi

if [[ "$LFS_VERSION" == "11.3" ]] || [[ "$LFS_VERSION" == "12.0" ]] || [[ "$LFS_VERSION" == "12.1" ]] || [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]]; then
	mlist=m64,m32,mx32
	../configure										\
		--target=$LFS_TGT								\
		--prefix=$LFS/tools								\
		--with-glibc-version=$GLIBC_VERSION				\
		--with-sysroot=$LFS								\
		--with-newlib									\
		--without-headers								\
		--enable-default-pie							\
		--enable-default-ssp							\
		--enable-initfini-array							\
		--disable-nls									\
		--disable-shared								\
		--enable-multilib --with-multilib-list=$mlist	\
		--disable-decimal-float							\
		--disable-threads								\
		--disable-libatomic								\
		--disable-libgomp								\
		--disable-libquadmath							\
		--disable-libssp								\
		--disable-libvtv								\
		--disable-libstdcxx								\
		--enable-languages=c,c++						\
		--disable-bootstrap
		# --disable-bootstrap is needed for a stage one with matching LFS_TGT with the host is x86_64-linux-gnu
fi

make
make install

cd ..

if [[ "$LFS_VERSION" == "10.0" ]] || [[ "$LFS_VERSION" == "10.1" ]] || [[ "$LFS_VERSION" == "11.0" ]] || [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "11.3" ]];then
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
		$(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/install-tools/include/limits.h 

fi

if [[ "$LFS_VERSION" == "12.0" ]] || [[ "$LFS_VERSION" == "12.1" ]] || [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]];then
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
		$(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/include/limits.h 
fi