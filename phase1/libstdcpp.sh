# Libstdc++ Phase 1
GCC_VERSION=$((basename $PKG_GCC .tar.xz) | cut -d "-" -f 2)

mkdir build
cd build

if [[ "$MULTILIB" == "true" ]]; then
	../libstdc++-v3/configure           \
		--host=$LFS_TGT                 \
		--build=$(../config.guess)      \
		--prefix=/usr                   \
		--enable-multilib               \
		--disable-nls                   \
		--disable-libstdcxx-pch         \
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$GCC_VERSION

else
	../libstdc++-v3/configure           \
		--host=$LFS_TGT                 \
		--build=$(../config.guess)      \
		--prefix=/usr                   \
		--disable-multilib              \
		--disable-nls                   \
		--disable-libstdcxx-pch         \
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$GCC_VERSION
fi

make
make DESTDIR=$LFS install

if [[ "$LFS_VERSION" == "11.2" ]]; then
	rm -v $LFS/usr/lib/lib{stdc++,stdc++fs,supc++}.la
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
fi
