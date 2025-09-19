# Flex Phase 4
FLEX_VERSION=$((basename $PKG_FLEX .tar.xz) | cut -d "-" -f 2)

if [ -s /usr/bin/lex ]; then unlink /usr/bin/lex; fi
if [ -s /usr/share/man/man1/lex.1 ]; then unlink /usr/share/man/man1/lex.1; fi

./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-$FLEX_VERSION \
            --disable-static

make

if $RUN_TESTS
then
    set +e
    make check 
    set -e
fi

make install

ln -s flex /usr/bin/lex

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]];then
	ln -s flex.1 /usr/share/man/man1/lex.1
fi