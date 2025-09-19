# Make Phase 2
if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]];then
	./configure --prefix=/usr   \
				--without-guile \
				--host=$LFS_TGT \
				--build=$(build-aux/config.guess)
fi

if [[ "$LFS_VERSION" == "12.4" ]];then
	./configure --prefix=/usr   \
				--host=$LFS_TGT \
				--build=$(build-aux/config.guess)
fi

make
make DESTDIR=$LFS install

