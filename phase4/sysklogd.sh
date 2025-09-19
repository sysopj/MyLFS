# Sysklogd Phase 4
SYSKLOG_VERSION=$((basename $PKG_SYSKLOGD .tar.xz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
	sed -i 's/union wait/int/' syslogd.c

	make

	make BINDIR=/sbin install
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	./configure --prefix=/usr      \
				--sysconfdir=/etc  \
				--runstatedir=/run \
				--without-logger
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	./configure --prefix=/usr      \
				--sysconfdir=/etc  \
				--runstatedir=/run \
				--without-logger   \
				--disable-static   \
				--docdir=/usr/share/doc/sysklogd-$SYSKLOG_VERSION
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	make

	make install

cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# Do not open any internet ports.
secure_mode 2

# End /etc/syslog.conf
EOF
fi