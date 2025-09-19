# Bc Phase 4
if [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "11.3" ]] || [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]];then
	CC=gcc ./configure --prefix=/usr -G -O3 -r
fi

if [[ "$LFS_VERSION" == "12.4" ]];then
	CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r
fi

make

if $RUN_TESTS
then
    set +e
    make test
    set -e
fi

make install
