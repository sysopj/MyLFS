# Util Linux Phase 3
mkdir -p /var/lib/hwclock

UTILLINUX_VERSION=$((basename $PKG_UTILLINUX .tar.xz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]];then
	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --libdir=/usr/lib    \
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
            runstatedir=/run
			
	make
	make install
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	mkdir -pv /var/lib/hwclock
fi

if [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "false" ]]; then
	./configure --libdir=/usr/lib     \
				--runstatedir=/run    \
				--disable-chfn-chsh   \
				--disable-login       \
				--disable-nologin     \
				--disable-su          \
				--disable-setpriv     \
				--disable-runuser     \
				--disable-pylibmount  \
				--disable-static      \
				--disable-liblastlog2 \
				--without-python      \
				ADJTIME_PATH=/var/lib/hwclock/adjtime \
				--docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION
			
	make
	make install
fi

if [[ "$LFS_VERSION" == "12.2" ]] && [[ "$MULTILIB" == "true" ]]; then
	#X64 bit
	./configure --libdir=/usr/lib     \
            --runstatedir=/run    \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION
			
	make
	make install
	
	#32 bit
	make distclean
	CC="gcc -m32" \
	./configure --host=$LFS_TGT32 \
            --libdir=/usr/lib32      \
            --runstatedir=/run       \
            --docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime
			
	make
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
	
	#x32 bit
	make distclean
	CC="gcc -mx32" \
	./configure --host=$LFS_TGTX32 \
            --libdir=/usr/libx32     \
            --runstatedir=/run       \
            --docdir=/usr/share/doc/util-linux-$UTILLINUX_VERSION \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime			
	make
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi



