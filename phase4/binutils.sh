# Binutils Phase 4
if [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "11.3" ]];then
	EXPECTOUT=$(expect -c 'spawn ls')
	if [ "$EXPECTOUT" != "$(echo -ne 'spawn ls\r\n')" ]
	then
		echo $EXPECTOUT
		exit 1
	fi
fi

if [[ -f ../$(basename $PATCH_BINUTILS) ]]; then
	patch -Np1 -i ../$(basename $PATCH_BINUTILS)
fi

if [[ "$LFS_VERSION" == "11.0" ]];then
	sed -i '63d' etc/texi2pod.pl
	find -name \*.1 -delete
fi

if [[ "$LFS_VERSION" == "11.1" ]];then
	sed -e '/R_386_TLS_LE /i \   || (TYPE) == R_386_TLS_IE \\' \
		-i ./bfd/elfxx-x86.h
fi

mkdir build
cd build

if [[ "$LFS_VERSION" == "11.1" ]];then
	../configure --prefix=/usr       \
				 --enable-gold       \
				 --enable-ld=default \
				 --enable-plugins    \
				 --enable-shared     \
				 --disable-werror    \
				 --enable-64-bit-bfd \
				 --with-system-zlib
fi

if [[ "$LFS_VERSION" == "11.2" ]];then
	../configure --prefix=/usr       \
				 --sysconfdir=/etc   \
				 --enable-gold       \
				 --enable-ld=default \
				 --enable-plugins    \
				 --enable-shared     \
				 --disable-werror    \
				 --enable-64-bit-bfd \
				 --with-system-zlib
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "false" ]]; then
	../configure --prefix=/usr       \
				 --sysconfdir=/etc   \
				 --enable-gold       \
				 --enable-ld=default \
				 --enable-plugins    \
				 --enable-shared     \
				 --disable-werror    \
				 --enable-64-bit-bfd \
				 --enable-new-dtags  \
				 --with-system-zlib  \
				 --enable-default-hash-style=gnu
fi

if [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "false" ]]; then
	../configure --prefix=/usr       \
				 --sysconfdir=/etc   \
				 --enable-ld=default \
				 --enable-plugins    \
				 --enable-shared     \
				 --disable-werror    \
				 --enable-64-bit-bfd \
				 --enable-new-dtags  \
				 --with-system-zlib  \
				 --enable-default-hash-style=gnu
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]]; then
	../configure --prefix=/usr       \
				 --sysconfdir=/etc   \
				 --enable-gold       \
				 --enable-ld=default \
				 --enable-plugins    \
				 --enable-shared     \
				 --disable-werror    \
				 --enable-64-bit-bfd \
				 --with-system-zlib  \
				 --enable-default-hash-style=gnu \
				 --enable-multilib
fi

if [[ "$LFS_VERSION" == "12.4" ]] && [[ "$MULTILIB" == "true" ]]; then
	../configure --prefix=/usr       \
				 --sysconfdir=/etc   \
				 --enable-ld=default \
				 --enable-plugins    \
				 --enable-shared     \
				 --disable-werror    \
				 --enable-64-bit-bfd \
				 --with-system-zlib  \
				 --enable-default-hash-style=gnu \
				 --enable-multilib
fi

make tooldir=/usr

if $RUN_TESTS
then
    set +e
    make -k check 
	grep '^FAIL:' $(find -name '*.log')
    set -e
fi

make tooldir=/usr install

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]];then
	rm -f /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]];then
	rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a
fi

if [[ "$LFS_VERSION" == "12.4" ]];then
	rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a /usr/share/doc/gprofng/
fi