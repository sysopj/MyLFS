# Eudev Phase 4

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr           \
				--bindir=/usr/sbin      \
				--sysconfdir=/etc       \
				--enable-manpages       \
				--disable-static

	make

	mkdir -p /usr/lib/udev/rules.d
	mkdir -p /etc/udev/rules.d

	if $RUN_TESTS
	then
		set +e
		make check
		set -e
	fi

	make install

	tar -xvf ../$(basename $PKG_UDEVLFS)
	make -f $(basename $PKG_UDEVLFS .tar.xz)/Makefile.lfs install

	udevadm hwdb --update
	
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	sed -i -e 's/GROUP="render"/GROUP="video"/' \
		   -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
	sed '/systemd-sysctl/s/^/#/' -i rules.d/99-systemd.rules.in
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	sed '/NETWORK_DIRS/s/systemd/udev/' -i src/basic/path-lookup.h
fi

if [[ "$LFS_VERSION" == "12.3" ]]; then
	sed -e '/NETWORK_DIRS/s/systemd/udev/' -i src/libsystemd/sd-network/network-util.h
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	mkdir -p build
	cd       build

	meson setup ..                  \
		  --prefix=/usr             \
		  --buildtype=release       \
		  -D mode=release           \
		  -D dev-kvm-mode=0660      \
		  -D link-udev-shared=false \
		  -D logind=false           \
		  -D vconsole=false
		  
	export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | \
						  awk '{print $3}' | tr -d ",'" | grep -v 'udevadm')
	ninja udevadm systemd-hwdb                                           \
		  $(ninja -n | grep -Eo '(src/(lib)?udev|rules.d|hwdb.d)/[^ ]*') \
		  $(realpath libudev.so --relative-to .)                         \
		  $udev_helpers
		  
	install -vm755 -d {/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
	install -vm755 -d /usr/{lib,share}/pkgconfig
	install -vm755 udevadm                             /usr/bin/
	install -vm755 systemd-hwdb                        /usr/bin/udev-hwdb
	ln      -svfn  ../bin/udevadm                      /usr/sbin/udevd
	cp      -av    libudev.so{,*[0-9]}                 /usr/lib/
	install -vm644 ../src/libudev/libudev.h            /usr/include/
	install -vm644 src/libudev/*.pc                    /usr/lib/pkgconfig/
	install -vm644 src/udev/*.pc                       /usr/share/pkgconfig/
	install -vm644 ../src/udev/udev.conf               /etc/udev/
	install -vm644 rules.d/* ../rules.d/README         /usr/lib/udev/rules.d/
	install -vm644 $(find ../rules.d/*.rules \
						  -not -name '*power-switch*') /usr/lib/udev/rules.d/
	install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README} /usr/lib/udev/hwdb.d/
	install -vm755 $udev_helpers                       /usr/lib/udev
	install -vm644 ../network/99-default.link          /usr/lib/udev/network

	tar -xvf ../../$(basename $PKG_UDEVLFS)
	make -f $(basename $PKG_UDEVLFS .tar.xz)/Makefile.lfs install

	tar -xf ../../$(basename $PKG_SYSTEMDDOCS)                            \
		--no-same-owner --strip-components=1                              \
		-C /usr/share/man --wildcards '*/udev*' '*/libudev*'              \
									  '*/systemd.link.5'                  \
									  '*/systemd-'{hwdb,udevd.service}.8

	sed 's|systemd/network|udev/network|'                                 \
		/usr/share/man/man5/systemd.link.5                                \
	  > /usr/share/man/man5/udev.link.5

	sed 's/systemd\(\\\?-\)/udev\1/' /usr/share/man/man8/systemd-hwdb.8   \
								   > /usr/share/man/man8/udev-hwdb.8

	sed 's|lib.*udevd|sbin/udevd|'                                        \
		/usr/share/man/man8/systemd-udevd.service.8                       \
	  > /usr/share/man/man8/udevd.8

	rm /usr/share/man/man*/systemd*

	unset udev_helpers
	
	
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	rm -rf *
	PKG_CONFIG_PATH="/usr/lib32/pkgconfig" \
	CC="gcc -m32 -march=i686"              \
	CXX="g++ -m32 -march=i686"             \
	LANG=en_US.UTF-8                       \
	meson setup \
		  --prefix=/usr                 \
		  --buildtype=release           \
		  -Dmode=release                \
		  -Ddev-kvm-mode=0660           \
		  -Dlink-udev-shared=false      \
		  -Dlogind=false                \
		  -Dvconsole=false              \
		  ..
	ninja \
		  $(grep -o -E "^build (src/libudev|src/udev)[^:]*" \
			build.ninja | awk '{ print $2 }')                              \
		  $(realpath libudev.so --relative-to .)


	mkdir -pv /usr/lib32/pkgconfig &&
	cp -av libudev.so{,*[0-9]} /usr/lib32/ &&
	sed -e "s;/usr/lib;&32;g" src/libudev/libudev.pc > /usr/lib32/pkgconfig/libudev.pc

	#x32 ABI
	rm -rf *
	PKG_CONFIG_PATH="/usr/libx32/pkgconfig" \
	CC="gcc -mx32"                          \
	CXX="g++ -mx32"                         \
	CFLAGS+=" -Wno-error=shift-overflow"    \
	CXXFLAGS+=" -Wno-error=shift-overflow"  \
	LANG=en_US.UTF-8                        \
	meson setup \
		  --prefix=/usr                 \
		  --buildtype=release           \
		  -Dmode=release                \
		  -Ddev-kvm-mode=0660           \
		  -Dlink-udev-shared=false      \
		  -Dlogind=false                \
		  -Dvconsole=false              \
		  ..
	ninja \
		  $(grep -o -E "^build (src/libudev|src/udev)[^:]*" \
			build.ninja | awk '{ print $2 }')                              \
		  $(realpath libudev.so --relative-to .)
	mkdir -pv /usr/libx32/pkgconfig &&
	cp -av libudev.so{,*[0-9]} /usr/libx32/ &&
	sed -e "s;/usr/lib;&x32;g" src/libudev/libudev.pc > /usr/libx32/pkgconfig/libudev.pc
fi

udev-hwdb update