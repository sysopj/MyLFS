# Libxcrypt Phase 4
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