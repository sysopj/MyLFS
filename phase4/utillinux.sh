# Util-linux Phase 4
UTILLINUX_VERSION=$((basename $PKG_UTILLINUX .tar.xz) | cut -d "-" -f 3)

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
				--bindir=/usr/bin    \
				--libdir=/usr/lib    \
				--sbindir=/usr/sbin  \
				--docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION \
				--disable-chfn-chsh  \
				--disable-login      \
				--disable-nologin    \
				--disable-su         \
				--disable-setpriv    \
				--disable-runuser    \
				--disable-pylibmount \
				--disable-static     \
				--without-python     \
				--without-systemd    \
				--without-systemdsystemunitdir
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$LFSINIT" == "sysvinit" ]]; then
	./configure --bindir=/usr/bin     \
				--libdir=/usr/lib     \
				--runstatedir=/run    \
				--sbindir=/usr/sbin   \
				--disable-chfn-chsh   \
				--disable-login       \
				--disable-nologin     \
				--disable-su          \
				--disable-setpriv     \
				--disable-runuser     \
				--disable-pylibmount  \
				--disable-liblastlog2 \
				--disable-static      \
				--without-python      \
				--without-systemd     \
				--without-systemdsystemunitdir        \
				ADJTIME_PATH=/var/lib/hwclock/adjtime \
				--docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$LFSINIT" == "systemd" ]]; then
	./configure --bindir=/usr/bin     \
				--libdir=/usr/lib     \
				--runstatedir=/run    \
				--sbindir=/usr/sbin   \
				--disable-chfn-chsh   \
				--disable-login       \
				--disable-nologin     \
				--disable-su          \
				--disable-setpriv     \
				--disable-runuser     \
				--disable-pylibmount  \
				--disable-liblastlog2 \
				--disable-static      \
				--without-python      \
				ADJTIME_PATH=/var/lib/hwclock/adjtime \
				--docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION
fi

make
touch /etc/fstab

if $RUN_TESTS
then
    set +e
    chown -Rv tester .
    su tester -c "make -k check"
    set -e
fi

make install

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

	mv /usr/bin/ncursesw6-config{,.tmp}

	CC="gcc -m32" \
	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
				--host=i686-pc-linux-gnu \
				--libdir=/usr/lib32      \
				--runstatedir=/run       \
				--sbindir=/usr/sbin      \
				--docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION \
				--disable-chfn-chsh      \
				--disable-login          \
				--disable-nologin        \
				--disable-su             \
				--disable-setpriv        \
				--disable-runuser        \
				--disable-pylibmount     \
				--disable-liblastlog2    \
				--disable-static         \
				--without-python         \
				--without-systemd        \
				--without-systemdsystemunitdir

	mv /usr/bin/ncursesw6-config{.tmp,}

	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
		
	#x32bit
	make distclean

	mv /usr/bin/ncursesw6-config{,.tmp}

	CC="gcc -mx32" \
	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
				--host=x86_64-pc-linux-gnux32 \
				--libdir=/usr/libx32  \
				--runstatedir=/run    \
				--sbindir=/usr/sbin   \
				--docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION \
				--disable-chfn-chsh   \
				--disable-login       \
				--disable-nologin     \
				--disable-su          \
				--disable-setpriv     \
				--disable-runuser     \
				--disable-pylibmount  \
				--disable-liblastlog2 \
				--disable-static      \
				--without-python      \
				--without-systemd     \
				--without-systemdsystemunitdir

	mv /usr/bin/ncursesw6-config{.tmp,}

	make

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi