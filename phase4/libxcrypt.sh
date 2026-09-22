# Libxcrypt Phase 4

GLIBC_VER=$(basename $PKG_GLIBC .tar.xz | cut -d "-" -f 2)
GLIBC_VER_MAJ=$(echo $GLIBC_VER | cut -d "." -f 1)
GLIBC_VER_MIN=$(echo $GLIBC_VER | cut -d "." -f 2)

GLIB_2_43_FIX_REQ=false
[[ $GLIBC_VER_MAJ -ge "2" ]] && [[ $GLIBC_VER_MIN -ge "43" ]] && GLIB_2_43_FIX_REQ=true
[[ $GLIB_2_43_FIX_REQ == true ]] && sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c

./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean
	
	CC="gcc -m32" \
	./configure --prefix=/usr                \
				--host=i686-pc-linux-gnu     \
				--libdir=/usr/lib32          \
				--enable-hashes=strong,glibc \
				--enable-obsolete-api=glibc  \
				--disable-static             \
				--disable-failure-tokens
	
	make
	
	cp -av .libs/libcrypt.so* /usr/lib32/ &&
	make install-pkgconfigDATA &&
	ln -svf libxcrypt.pc /usr/lib32/pkgconfig/libcrypt.pc
fi
if [[ "$MULTILIB" == "true" ]] && [[ "$MULTILIB_mx32" == "true" ]]; then	
	#x32bit
	make distclean
	
	CC="gcc -mx32" \
	./configure --prefix=/usr                 \
				--host=x86_64-pc-linux-gnux32 \
				--libdir=/usr/libx32          \
				--enable-hashes=strong,glibc  \
				--enable-obsolete-api=glibc   \
				--disable-static              \
				--disable-failure-tokens
				
	make
	
	cp -av .libs/libcrypt.so* /usr/libx32/ &&
	make install-pkgconfigDATA &&
	ln -svf libxcrypt.pc /usr/libx32/pkgconfig/libcrypt.pc
fi