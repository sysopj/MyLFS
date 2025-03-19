# Expect Phase 4
EXPECT_VERSION=$((basename $PKG_EXPECT .tar.gz) | cut -d "-" -f 2 )

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]];then
	python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
fi

if [[ $PATCH_EXPECT ]]; then
	patch -Np1 -i ../$(basename $PATCH_EXPECT)
fi

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]];then
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]];then
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
fi

make

if $RUN_TESTS
then
    set +e
    make test 
    set -e
fi

make install

ln -sf $EXPECT_VERSION/lib$EXPECT_VERSION.so /usr/lib

