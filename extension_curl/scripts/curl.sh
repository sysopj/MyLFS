CURL_VERSION=$((basename $PKG_CURL .tar.xz) | cut -d "-" -f 2)

if [[ $LFS_VERSION == "12.2" ]] || [[ $LFS_VERSION == "12.3" ]] || [[ $LFS_VERSION == "12.4" ]] || [[ $LFS_VERSION == "13.0" ]]; then
	./configure --prefix=/usr                           \
				--disable-static                        \
				--with-openssl                          \
				--enable-threaded-resolver              \
				--with-ca-path=/etc/ssl/certs

	make

	make install

	rm -rf docs/examples/.deps

	find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \;

	install -v -d -m755 /usr/share/doc/curl-$CURL_VERSION
	cp -v -R docs/*     /usr/share/doc/curl-$CURL_VERSION

fi

if [[ $LFS_VERSION == "13.1" ]]; then
	./configure --prefix=/usr    \
				--disable-static \
				--with-openssl   \
				--without-libpsl \
				--with-ca-path=/etc/ssl/certs
	make
					
	make install

	rm -rf docs/examples/.deps

	find docs \( -name Makefile\* -o  \
				 -name \*.1       -o  \
				 -name \*.3       -o  \
				 -name CMakeLists.txt \) -delete

	cp -v -R docs -T /usr/share/doc/curl-$CURL_VERSION
fi