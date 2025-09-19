# OpenSSL Phase 4
OPENSSL_VERSION=$((basename $PKG_OPENSSL .tar.gz) | cut -d "-" -f 2)

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]] && $RUN_TESTS; then
    set +e
    make test
    set -e
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && $RUN_TESTS; then
    set +e
    HARNESS_JOBS=$(nproc) make test
    set -e
fi

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv /usr/share/doc/openssl /usr/share/doc/openssl-$OPENSSL_VERSION

cp -fr doc/* /usr/share/doc/openssl-$OPENSSL_VERSION

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

	./config --prefix=/usr         \
			 --openssldir=/etc/ssl \
			 --libdir=lib32        \
			 shared                \
			 zlib-dynamic          \
			 linux-x86

	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR	
	
	#x32bit
	make distclean

	./config --prefix=/usr         \
			 --openssldir=/etc/ssl \
			 --libdir=libx32       \
			 shared                \
			 zlib-dynamic          \
			 linux-x32

	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR	
fi