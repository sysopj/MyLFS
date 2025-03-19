# Texinfo Phase 3

if [[ "$LFS_VERSION" == "11.1" ]]; then
	sed -e 's/__attribute_nonnull__/__nonnull/' \
		-i gnulib/lib/malloc/dynarray-skeleton.c
fi

./configure --prefix=/usr

make
make install

