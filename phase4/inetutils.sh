# Inetutils Phase 4

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c
fi

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

mv /usr/{,s}bin/ifconfig

