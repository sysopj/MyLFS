# Groff Phase 4
PAGE=$PAPER_SIZE ./configure --prefix=/usr

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	make -j1
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	make
fi

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

