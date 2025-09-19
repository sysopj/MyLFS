# Binutils Phase 2
sed '6009s/$add_dir//' -i ltmain.sh

mkdir build
cd build


if [[ "$LFS_VERSION" == "11.1" ]] && [[ "$MULTILIB" == "false" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--disable-werror           \
		--enable-64-bit-bfd
	
	make
	make DESTDIR=$LFS install
fi

if [[ "$LFS_VERSION" == "11.1" ]] && [[ "$MULTILIB" == "true" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--disable-werror           \
		--enable-64-bit-bfd 	   \
		--enable-multilib
	
	make
	make DESTDIR=$LFS install
fi

if [[ "$LFS_VERSION" == "11.2" ]] && [[ "$MULTILIB" == "false" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd
	
	make
	make DESTDIR=$LFS install

	rm $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la}
fi

if [[ "$LFS_VERSION" == "11.2" ]] && [[ "$MULTILIB" == "true" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd 	   \
		--enable-multilib
	
	make
	make DESTDIR=$LFS install

	rm $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la}
fi

if [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "false" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd        \
		--enable-default-hash-style=gnu
		
	make
	make DESTDIR=$LFS install

	rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
fi

if [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "true" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd        \
		--enable-default-hash-style=gnu \
		--enable-multilib
		
	make
	make DESTDIR=$LFS install

	rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "false" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd        \
		--enable-new-dtags         \
		--enable-default-hash-style=gnu
		
	make
	make DESTDIR=$LFS install

	rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "true" ]];then
	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd        \
		--enable-new-dtags         \
		--enable-default-hash-style=gnu \
		--enable-multilib
		
	make
	make DESTDIR=$LFS install

	rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
fi



