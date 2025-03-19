# SystemD Phase 4

if [ -f ../$(basename $PATCH_SYSTEMD) ]; then
	patch -Np1 -i ../$(basename $PATCH_SYSTEMD)
fi

sed -e 's/GROUP="render"/GROUP="video"/'	\
	-e 's/GROUP="sgx", //' 					\
	-i rules.d/50-udev-default.rules.in


mkdir -p build
cd       build

if [[ "$LFS_VERSION" == "11.2" ]]; then
meson --prefix=/usr                 \
      --buildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Dpamconfdir=no               \
      -Ddocdir=/usr/share/doc/$(basename $PKG_SYSTEMD .tar.gz) \
      ..
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
meson setup ..                \
      --prefix=/usr           \
      --buildtype=release     \
      -D default-dnssec=no    \
      -D firstboot=false      \
      -D install-tests=false  \
      -D ldconfig=false       \
      -D sysusers=false       \
      -D rpmmacrosdir=no      \
      -D homed=disabled       \
      -D userdb=false         \
      -D man=disabled         \
      -D mode=release         \
      -D pamconfdir=no        \
      -D dev-kvm-mode=0660    \
      -D nobody-group=nogroup \
      -D sysupdate=disabled   \
      -D ukify=disabled       \
      -D docdir=/usr/share/doc/$(basename $PKG_SYSTEMD .tar.gz)
fi

ninja

ninja install

tar -xf ../../$(basename $PKG_SYSTEMDDOCS) \
    --no-same-owner --strip-components=1   \
    -C /usr/share/man
	
systemd-machine-id-setup

systemctl preset-all

if [[ "$LFS_VERSION" == "11.2" ]]; then
	systemctl disable systemd-sysupdate
fi

#9.10. Systemd Usage and Configuration
mkdir -p /etc/tmpfiles.d
cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d

mkdir -p /etc/systemd/coredump.conf.d

cat > /etc/systemd/coredump.conf.d/maxuse.conf << EOF
[Coredump]
MaxUse=5G
EOF

#9.10. Systemd Usage and Configuration
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no
EOF

mkdir -p /etc/tmpfiles.d
cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d


mkdir -p /etc/systemd/coredump.conf.d
cat > /etc/systemd/coredump.conf.d/maxuse.conf << EOF
[Coredump]
MaxUse=5G
EOF

if [[ "$MULTILIB" == "true" ]]; then
	#32bit
	rm -rf *
	
	PKG_CONFIG_PATH="/usr/lib32/pkgconfig" \
	CC="gcc -m32"                        \
	CXX="g++ -m32"                       \
	LANG=en_US.UTF-8                     \
	meson setup ..                       \
		  --prefix=/usr                  \
		  --libdir=/usr/lib32            \
		  --buildtype=release            \
		  -D default-dnssec=no           \
		  -D firstboot=false             \
		  -D install-tests=false         \
		  -D ldconfig=false              \
		  -D sysusers=false              \
		  -D rpmmacrosdir=no             \
		  -D homed=disabled              \
		  -D userdb=false                \
		  -D man=disabled                \
		  -D mode=release 
	
	LANG=en_US.UTF-8 ninja
	
	LANG=en_US.UTF-8 DESTDIR=$PWD/DESTDIR ninja install
	cp -av DESTDIR/usr/lib32/libsystemd.so* /usr/lib32/
	cp -av DESTDIR/usr/lib32/libudev.so* /usr/lib32/
	cp -v  DESTDIR/usr/lib32/pkgconfig/* /usr/lib32/pkgconfig/
	rm -rf DESTDIR
	
	#x32bit
	rm -rf *
	
	PKG_CONFIG_PATH="/usr/libx32/pkgconfig" \
	CC="gcc -mx32"                       \
	CXX="g++ -mx32"                      \
	LANG=en_US.UTF-8                     \
	meson setup ..                       \
		  --prefix=/usr                  \
		  --libdir=/usr/libx32           \
		  --buildtype=release            \
		  -D default-dnssec=no           \
		  -D firstboot=false             \
		  -D install-tests=false         \
		  -D ldconfig=false              \
		  -D sysusers=false              \
		  -D rpmmacrosdir=no             \
		  -D homed=false                 \
		  -D userdb=false                \
		  -D man=disabled                \
		  -D mode=release 
	
	LANG=en_US.UTF-8 ninja
	
	LANG=en_US.UTF-8 DESTDIR=$PWD/DESTDIR ninja install
	cp -av DESTDIR/usr/libx32/libsystemd.so* /usr/libx32/
	cp -av DESTDIR/usr/libx32/libudev.so* /usr/libx32/
	cp -v  DESTDIR/usr/libx32/pkgconfig/* /usr/libx32/pkgconfig/
	rm -rf DESTDIR
fi	