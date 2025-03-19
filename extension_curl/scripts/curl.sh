CURL_VERSION=$((basename $PKG_CURL .tar.xz) | cut -d "-" -f 2)

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
