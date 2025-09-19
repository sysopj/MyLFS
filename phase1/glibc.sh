# Glibc Phase 1
case $(uname -m) in
    i?86)
        ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64)
        ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
        ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

if [[ -f ../$(basename $PATCH_GLIBC) ]]; then
	patch -Np1 -i ../$(basename $PATCH_GLIBC)
fi

mkdir build
cd build

echo "rootsbindir=/usr/sbin" > configparms

#GLIBC_VERSION=$((basename $PKG_GLIBC .tar.xz) | cut -d "-" -f 2)
GCC_VERSION=$((basename $PKG_GCC .tar.xz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "10.0" ]] || [[ "$LFS_VERSION" == "10.1" ]] || [[ "$LFS_VERSION" == "11.0" ]] || [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGT                    \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=3.2                \
		  --with-headers=$LFS/usr/include    \
		  libc_cv_slibdir=/usr/lib
	
	make
  	make DESTDIR=$LFS install

	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
	  
	$LFS/tools/libexec/gcc/$LFS_TGT/$GCC_VERSION/install-tools/mkheaders
fi

if [[ "$LFS_VERSION" == "12.0" ]];then
	../configure                             \
		--prefix=/usr                      \
		--host=$LFS_TGT                    \
		--build=$(../scripts/config.guess) \
		--enable-kernel=4.14               \
		--with-headers=$LFS/usr/include    \
		libc_cv_slibdir=/usr/lib
	  
  	make DESTDIR=$LFS install

	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
fi

if [[ "$LFS_VERSION" == "12.1" ]] || [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "false" ]]; then
	../configure                             \
		--prefix=/usr                      \
		--host=$LFS_TGT                    \
		--build=$(../scripts/config.guess) \
		--enable-kernel=4.19               \
		--with-headers=$LFS/usr/include    \
		--disable-nscd                     \
		libc_cv_slibdir=/usr/lib
	
	make
  	make DESTDIR=$LFS install

	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
fi

if [[ "$LFS_VERSION" == "12.1" ]] || [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "true" ]]; then
	#64 bit
	../configure                           \
		--prefix=/usr                      \
		--host=$LFS_TGT                    \
		--build=$(../scripts/config.guess) \
		--enable-kernel=4.19               \
		--with-headers=$LFS/usr/include    \
		--disable-nscd                     \
		libc_cv_slibdir=/usr/lib
	  
	make
	make DESTDIR=$LFS install
	  
	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
	 
	#32 Bit
	make clean
	find .. -name "*.a" -delete
	
	CC="$LFS_TGT-gcc -m32" \
	CXX="$LFS_TGT-g++ -m32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGT32                  \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=4.19               \
		  --with-headers=$LFS/usr/include    \
		  --disable-nscd                     \
		  --libdir=/usr/lib32                \
		  --libexecdir=/usr/lib32            \
		  libc_cv_slibdir=/usr/lib32
		  
	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/lib32 $LFS/usr/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-32.h \
				   $LFS/usr/include/gnu/
	ln -svf ../lib32/ld-linux.so.2 $LFS/lib/ld-linux.so.2

	#x32 bit
	make clean
	find .. -name "*.a" -delete

	CC="$LFS_TGT-gcc -mx32" \
	CXX="$LFS_TGT-g++ -mx32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGTX32                 \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=4.19                \
		  --with-headers=$LFS/usr/include    \
		  --disable-nscd                     \
		  --libdir=/usr/libx32               \
		  --libexecdir=/usr/libx32           \
		  libc_cv_slibdir=/usr/libx32

	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/libx32 $LFS/usr/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-x32.h \
				   $LFS/usr/include/gnu/
	ln -svf ../libx32/ld-linux-x32.so.2 $LFS/lib/ld-linux-x32.so.2
	
	PASS=true
fi

if [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "false" ]]; then
	../configure                           \
		--prefix=/usr                      \
		--host=$LFS_TGT                    \
		--build=$(../scripts/config.guess) \
		--enable-kernel=5.4                \
		--with-headers=$LFS/usr/include    \
		--disable-nscd                     \
		libc_cv_slibdir=/usr/lib
	
	make
  	make DESTDIR=$LFS install

	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
fi

if [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "false" ]]; then
	../configure                           \
		--prefix=/usr                      \
		--host=$LFS_TGT                    \
		--build=$(../scripts/config.guess) \
		--enable-kernel=5.4                \
		--disable-nscd                     \
		libc_cv_slibdir=/usr/lib
	
	make
  	make DESTDIR=$LFS install

	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
fi

if [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]]; then
	#64 bit
	../configure                           \
		--prefix=/usr                      \
		--host=$LFS_TGT                    \
		--build=$(../scripts/config.guess) \
		--enable-kernel=5.4                \
		--with-headers=$LFS/usr/include    \
		--disable-nscd                     \
		libc_cv_slibdir=/usr/lib
	  
	make
	make DESTDIR=$LFS install
	  
	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
	 
	#32 Bit
	make clean
	find .. -name "*.a" -delete
	
	CC="$LFS_TGT-gcc -m32" \
	CXX="$LFS_TGT-g++ -m32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGT32                  \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=5.4                \
		  --with-headers=$LFS/usr/include    \
		  --disable-nscd                     \
		  --libdir=/usr/lib32                \
		  --libexecdir=/usr/lib32            \
		  libc_cv_slibdir=/usr/lib32
		  
	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/lib32 $LFS/usr/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-32.h \
				   $LFS/usr/include/gnu/
	ln -svf ../lib32/ld-linux.so.2 $LFS/lib/ld-linux.so.2

	#x32 bit
	make clean
	find .. -name "*.a" -delete

	CC="$LFS_TGT-gcc -mx32" \
	CXX="$LFS_TGT-g++ -mx32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGTX32                 \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=5.4                 \
		  --with-headers=$LFS/usr/include    \
		  --disable-nscd                     \
		  --libdir=/usr/libx32               \
		  --libexecdir=/usr/libx32           \
		  libc_cv_slibdir=/usr/libx32

	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/libx32 $LFS/usr/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-x32.h \
				   $LFS/usr/include/gnu/
	ln -svf ../libx32/ld-linux-x32.so.2 $LFS/lib/ld-linux-x32.so.2
	
	PASS=true
fi

if [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "true" ]]; then
	#64 bit
	../configure                           \
		--prefix=/usr                      \
		--host=$LFS_TGT                    \
		--build=$(../scripts/config.guess) \
		--enable-kernel=5.4                \
		--disable-nscd                     \
		libc_cv_slibdir=/usr/lib
	  
	make
	make DESTDIR=$LFS install
	  
	sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
	 
	#32 Bit
	make clean
	find .. -name "*.a" -delete
	
	CC="$LFS_TGT-gcc -m32" \
	CXX="$LFS_TGT-g++ -m32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGT32                  \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=5.4                \
		  --disable-nscd                     \
		  --libdir=/usr/lib32                \
		  --libexecdir=/usr/lib32            \
		  libc_cv_slibdir=/usr/lib32
		  
	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/lib32 $LFS/usr/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-32.h \
				   $LFS/usr/include/gnu/
	ln -svf ../lib32/ld-linux.so.2 $LFS/lib/ld-linux.so.2

	#x32 bit
	make clean
	find .. -name "*.a" -delete

	CC="$LFS_TGT-gcc -mx32" \
	CXX="$LFS_TGT-g++ -mx32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=$LFS_TGTX32                 \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=5.4                \
		  --disable-nscd                     \
		  --libdir=/usr/libx32               \
		  --libexecdir=/usr/libx32           \
		  libc_cv_slibdir=/usr/libx32

	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/libx32 $LFS/usr/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-x32.h \
				   $LFS/usr/include/gnu/
	ln -svf ../libx32/ld-linux-x32.so.2 $LFS/lib/ld-linux-x32.so.2
	
	PASS=true
fi
