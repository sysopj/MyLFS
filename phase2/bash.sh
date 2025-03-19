# Bash Phase 2
if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr                   \
				--build=$(support/config.guess) \
				--host=$LFS_TGT                 \
				--without-bash-malloc
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	./configure --prefix=/usr                   \
				--build=$(sh support/config.guess) \
				--host=$LFS_TGT                 \
				--without-bash-malloc           \
				bash_cv_strtold_broken=no
fi

if [[ "$LFS_VERSION" == "12.3" ]]; then
	./configure --prefix=/usr                   \
				--build=$(sh support/config.guess) \
				--host=$LFS_TGT                 \
				--without-bash-malloc  
fi

make
make DESTDIR=$LFS install
ln -sv bash $LFS/bin/sh

