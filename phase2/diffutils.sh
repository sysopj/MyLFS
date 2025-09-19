# Diffutils Phase 2
if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]];then
	./configure --prefix=/usr \
				--host=$LFS_TGT
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]];then
	./configure --prefix=/usr \
				--host=$LFS_TGT \
				--build=$(./build-aux/config.guess)
fi

if [[ "$LFS_VERSION" == "12.4" ]];then
	./configure --prefix=/usr   \
				--host=$LFS_TGT \
				gl_cv_func_strcasecmp_works=y \
				--build=$(./build-aux/config.guess)
fi

make
make DESTDIR=$LFS install

