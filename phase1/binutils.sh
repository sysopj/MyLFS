# Binutils Phase 1
mkdir build
cd build

if [[ "$LFS_VERSION" == "10.0" ]] || [[ "$LFS_VERSION" == "10.1" ]] || [[ "$LFS_VERSION" == "11.0" ]] || [[ "$LFS_VERSION" == "11.1" ]] && [[ "$MULTILIB" == "false" ]];then
../configure \
    --prefix=$LFS/tools \
    --with-sysroot=$LFS \
    --target=$LFS_TGT \
    --disable-nls \
    --disable-werror
fi

if [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "11.3" ]] || [[ "$LFS_VERSION" == "12.0" ]] && [[ "$MULTILIB" == "false" ]];then
../configure \
    --prefix=$LFS/tools \
    --with-sysroot=$LFS \
    --target=$LFS_TGT \
    --disable-nls \
    --enable-gprofng=no \
    --disable-werror
fi

if [[ "$LFS_VERSION" == "10.0" ]] || [[ "$LFS_VERSION" == "10.1" ]] || [[ "$LFS_VERSION" == "11.0" ]] || [[ "$LFS_VERSION" == "11.1" ]]  && [[ "$MULTILIB" == "true" ]];then
../configure \
    --prefix=$LFS/tools \
    --with-sysroot=$LFS \
    --target=$LFS_TGT \
    --disable-nls \
    --disable-werror \
    --enable-multilib
fi

if [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "11.3" ]] || [[ "$LFS_VERSION" == "12.0" ]] && [[ "$MULTILIB" == "true" ]];then
../configure \
    --prefix=$LFS/tools \
    --with-sysroot=$LFS \
    --target=$LFS_TGT \
    --disable-nls \
    --enable-gprofng=no \
    --disable-werror \
    --enable-multilib
fi

if [[ "$LFS_VERSION" == "12.1" ]];then
../configure \
    --prefix=$LFS/tools \
    --with-sysroot=$LFS \
    --target=$LFS_TGT \
    --disable-nls \
    --enable-gprofng=no \
    --disable-werror \
	--enable-default-hash-style=gnu
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "false" ]];then
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-default-hash-style=gnu \
             --enable-new-dtags  \
             --disable-multilib
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "true" ]];then
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-default-hash-style=gnu \
             --enable-new-dtags  \
             --enable-multilib
fi

make

make install
