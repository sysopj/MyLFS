# Bash Phase 4
BASH_VERSION=$((basename $PKG_BASH .tar.gz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr                      \
				--docdir=/usr/share/doc/bash-$BASH_VERSION \
				--without-bash-malloc              \
				--with-installed-readline
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            bash_cv_strtold_broken=no \
            --docdir=/usr/share/doc/bash-$BASH_VERSION
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-$BASH_VERSION
fi

make

if $RUN_TESTS
then
    set +e
chown -R tester .
su -s /usr/bin/expect tester << EOF
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
    set -e
fi

make install

