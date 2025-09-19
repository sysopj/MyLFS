# D-Bus Phase 4

if [[ "$LFS_VERSION" == "12.2" ]]; then
	./configure --prefix=/usr                        \
				--sysconfdir=/etc                    \
				--localstatedir=/var                 \
				--runstatedir=/run                   \
				--enable-user-session                \
				--disable-static                     \
				--disable-doxygen-docs               \
				--disable-xml-docs                   \
				--docdir=/usr/share/doc/$(basename $PKG_DBUS .tar.xz ) \
				--with-system-socket=/run/dbus/system_bus_socket
				
	make

	if $RUN_TESTS
	then
		set +e
		make check
		set -e
	fi			
				
	make install
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	mkdir build
	cd    build

	meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..	
				
	ninja

	if $RUN_TESTS
	then
		set +e
		ninja test
		set -e
	fi			
				
	ninja install
fi

ln -sf /etc/machine-id /var/lib/dbus