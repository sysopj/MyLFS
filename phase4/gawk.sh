# Gawk Phase 4
GAWK_VERSION=$((basename $PKG_GAWK .tar.xz) | cut -d "-" -f 2)

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]] && $RUN_TESTS; then
    set +e
    make check
    set -e
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && $RUN_TESTS; then
    set +e
    chown -R tester .
    su tester -c "PATH=$PATH make check"
    set -e
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	rm -f /usr/bin/gawk-$GAWK_VERSION
fi

make install

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	ln -sv gawk.1 /usr/share/man/man1/awk.1
fi

mkdir -p /usr/share/doc/gawk-$GAWK_VERSION
cp doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-$GAWK_VERSION

