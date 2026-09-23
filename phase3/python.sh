# Python Phase 3
if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
fi

if [[ "$LFS_VERSION" == "12.4" ]] || [[ "$LFS_VERSION" == "13.0" ]] || [[ "$LFS_VERSION" == "13.1" ]]; then
./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython
fi

make
make install

