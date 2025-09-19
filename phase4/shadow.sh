# Shadow Phase 4
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
		-e 's:/var/spool/mail:/var/mail:'                 \
		-e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                \
		-i etc/login.defs
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
		-e 's:/var/spool/mail:/var/mail:'                   \
		-e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
		-i etc/login.defs
fi

if [[ "$CRACKLIB_SUPPORT" == "true" ]]; then
	sed -i 's:DICTPATH.*:DICTPATH\t/lib/cracklib/pw_dict:' etc/login.defs
fi

touch /usr/bin/passwd

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --sysconfdir=/etc \
				--disable-static  \
				--with-group-name-max-length=32
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	./configure --sysconfdir=/etc   \
				--disable-static    \
				--with-{b,yes}crypt \
				--without-libbsd    \
				--with-group-name-max-length=32
fi

make
make exec_prefix=/usr install
make -C man install-man

pwconv
grpconv

# This parameter causes useradd to create a mailbox file for each new user.
# sed -i '/MAIL/s/yes/no/' /etc/default/useradd

mkdir -p /etc/default
useradd -D --gid 999

sed -i '/MAIL/s/yes/no/' /etc/default/useradd

echo "root:$ROOT_PASSWD" | chpasswd

