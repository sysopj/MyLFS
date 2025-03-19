# Coreutils Phase 4
if [[ -f ../$(basename $PATCH_COREUTILS) ]]; then
	patch -Np1 -i ../$(basename $PATCH_COREUTILS)
fi

if [[ -f ../$(basename $PATCH_COREUTILS_CHMOD) ]]; then
	patch -Np1 -i ../$(basename $PATCH_COREUTILS_CHMOD)
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	autoreconf -fiv
fi

if [[ "$LFS_VERSION" == "12.3" ]]; then
	autoreconf -fv
	automake -af
fi

FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

make

if $RUN_TESTS
then
    set +e
    make NON_ROOT_USERNAME=tester check-root
    echo "dummy:x:102:tester" >> /etc/group
    chown -R tester . 
    su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
    sed -i '/dummy/d' /etc/group
    set -e
fi

make install

mv /usr/bin/chroot /usr/sbin
mv /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

