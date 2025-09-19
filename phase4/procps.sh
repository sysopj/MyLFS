# Procps-ng Phase 4
PROCPS_VERSION=$((basename $PKG_PROCPS .tar.xz) | cut -d "-" -f 3)

if [[ "$LFSINIT" == "sysvinit" ]]; then
	./configure --prefix=/usr                            \
				--docdir=/usr/share/doc/procps-ng-$PROCPS_VERSION  \
				--disable-static                         \
				--disable-kill
fi

if [[ "$LFSINIT" == "systemd" ]] && [[ "$LFS_VERSION" == "12.2" ]]; then
	./configure --prefix=/usr                            \
				--docdir=/usr/share/doc/procps-ng-$PROCPS_VERSION  \
				--disable-static                         \
				--disable-kill                          \
				--with-systemd
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$LFSINIT" == "systemd" ]]; then
	./configure --prefix=/usr                            \
				--docdir=/usr/share/doc/procps-ng-$PROCPS_VERSION  \
				--disable-static                         \
				--disable-kill                          \
				--enable-watch8bit                      \
				--with-systemd
fi

if [[ "$LFSINIT" == "sysvinit" ]]; then
	make
fi

if [[ "$LFSINIT" == "systemd" ]] && [[ "$LFS_VERSION" == "12.2" ]]; then
	make src_w_LDADD='$(LDADD) -lsystemd'
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && [[ "$LFSINIT" == "systemd" ]]; then
	make
fi

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]] && $RUN_TESTS; then
    set +e
    make check
    set -e
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] && $RUN_TESTS; then
    set +e
    chown -R tester .
    su tester -c "PATH=$PATH make check"
    set -e
fi

make install
