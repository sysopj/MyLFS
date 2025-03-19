# Texinfo Phase 4
./configure --prefix=/usr

if [[ "$LFS_VERSION" == "11.1" ]];then
	sed -e 's/__attribute_nonnull__/__nonnull/' \
		-i gnulib/lib/malloc/dynarray-skeleton.c
fi

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

make TEXMF=/usr/share/texmf install-tex
