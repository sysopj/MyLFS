#!/bin/bash
#
#	DillonSocietyLabs' Converstion Library for LFS's wget-list file to a config.sh for MyLFS's ALFS
#
#		Update info: Step 1) Copy function of previous version and update.
#							./static and ./template files are customized here
#					 Step 2) Place new wget-list in ./wget-lists as wget-list-$LFS_VERSION
#

#
#	WARNING: Do not make anything that references packages.sh as it will not get loaded yet.
#

# To fetch $LFS_VERSION, $MULTILIB, & $LFSINIT
if [[ $CONFIG_OVERRIDE == "true" ]]; then
	# Using batch Script
	# Load the following externally then call ./mylfs
	echo "External Configs Selected"
else
	# import config vars
	source ./config.sh
fi

function config_sysvinit(){
if [[ $LFSINIT == "sysvinit" ]]; then
cat << EOF > ./static/etc__sysconfig__clock
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

cat << EOF > ./static/etc__sysconfig__console
# Begin /etc/sysconfig/console

UNICODE="1"
FONT="Lat2-Terminus16"

# End /etc/sysconfig/console
EOF

cat << EOF > ./templates/etc__sysconfig__rc.site
# rc.site
# Optional parameters for boot scripts.

# Distro Information
# These values, if specified here, override the defaults
DISTRO="$OS_NAME" # The distro name
DISTRO_CONTACT="$OS_CONTACT" # Bug report address
DISTRO_MINI="$OS_VERSION_CODENAME" # Short name used in filenames for distro config

# Define custom colors used in messages printed to the screen

# Please consult 'man console_codes' for more information
# under the "ECMA-48 Set Graphics Rendition" section
#
# Warning: when switching from a 8bit to a 9bit font,
# the linux console will reinterpret the bold (1;) to
# the top 256 glyphs of the 9bit font.  This does
# not affect framebuffer consoles

# These values, if specified here, override the defaults
#BRACKET="\\033[1;34m" # Blue
#FAILURE="\\033[1;31m" # Red
#INFO="\\033[1;36m"    # Cyan
#NORMAL="\\033[0;39m"  # Grey
#SUCCESS="\\033[1;32m" # Green
#WARNING="\\033[1;33m" # Yellow

# Use a colored prefix
# These values, if specified here, override the defaults
#BMPREFIX="      "
#SUCCESS_PREFIX="${SUCCESS}  *  ${NORMAL} "
#FAILURE_PREFIX="${FAILURE}*****${NORMAL} "
#WARNING_PREFIX="${WARNING} *** ${NORMAL} "

# Manually set the right edge of message output (characters)
# Useful when resetting console font during boot to override
# automatic screen width detection
#COLUMNS=120

# Interactive startup
#IPROMPT="yes" # Whether to display the interactive boot prompt
#itime="3"    # The amount of time (in seconds) to display the prompt

# The total length of the distro welcome string, without escape codes
#wlen=$(echo "Welcome to ${DISTRO}" | wc -c )
#welcome_message="Welcome to ${INFO}${DISTRO}${NORMAL}"

# The total length of the interactive string, without escape codes
#ilen=$(echo "Press 'I' to enter interactive startup" | wc -c )
#i_message="Press '${FAILURE}I${NORMAL}' to enter interactive startup"

# Set scripts to skip the file system check on reboot
#FASTBOOT=yes

# Skip reading from the console
#HEADLESS=yes

# Write out fsck progress if yes
#VERBOSE_FSCK=no

# Speed up boot without waiting for settle in udev
#OMIT_UDEV_SETTLE=y

# Speed up boot without waiting for settle in udev_retry
#OMIT_UDEV_RETRY_SETTLE=yes

# Skip cleaning /tmp if yes
#SKIPTMPCLEAN=no

# For setclock
#UTC=1
#CLOCKPARAMS=

# For consolelog (Note that the default, 7=debug, is noisy)
#LOGLEVEL=7

# For network
#HOSTNAME=$LFS_HOSTNAME

# Delay between TERM and KILL signals at shutdown
#KILLDELAY=3

# Optional sysklogd parameters
#SYSKLOGD_PARMS="-m 0"

# Console parameters
#UNICODE=1
#KEYMAP="de-latin1"
#KEYMAP_CORRECTIONS="euro2"
#FONT="lat0-16 -m 8859-15"
#LEGACY_CHARSET=

EOF

cat << EOF > ./static/etc__syslog.conf
auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

EOF

cat << EOF > ./static/etc__inittab
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S06:once:/sbin/sulogin
s1:1:respawn:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

cat << EOF > ./templates/etc__sysconfig__ifconfig.$NIC_NAME
ONBOOT=yes
IFACE=$NIC_NAME
SERVICE=$NIC_SERVICE
IP=$NIC_IP
GATEWAY=$NIC_GATEWAY
PREFIX=$NIC_PREFIX
BROADCAST=$NIC_BROADCAST

EOF

cat << EOF > ./templates/etc__resolv.conf
nameserver $NIC_DNS1
# Google Public IPv4 DNS Addresses
#nameserver 8.8.8.8
#nameserver 8.8.4.4
EOF

echo '# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  #export LANG=<ll>_<CC>.<charmap><@modifiers>
  export LANG=en_US.iso88591
fi

# End /etc/profile
' > ./static/etc__profile

else
	if [ -f ./static/etc__sysconfig__clock ]; then
		rm -f ./static/etc__sysconfig__clock
	fi
	if [ -f ./static/etc__sysconfig__console ]; then
		rm -f ./static/etc__sysconfig__console
	fi
	if [ -f ./template/etc__sysconfig__rc.site ]; then
		rm -f ./template/etc__sysconfig__rc.site
	fi
	if [ -f ./static/etc__syslog.conf ]; then
		rm -f ./static/etc__syslog.conf
	fi
	if [ -f ./static/etc__inittab ]; then
		rm -f ./static/etc__inittab
	fi
	if [ -f ./templates/etc__sysconfig__ifconfig.* ]; then
		rm -f ./templates/etc__sysconfig__ifconfig.*
	fi
	if [ -f ./templates/etc__resolv.conf ]; then
		rm -f ./templates/etc__resolv.conf
	fi
fi
}

function config_systemd(){
if [[ $LFSINIT == "systemd" ]]; then
cat << EOF > ./templates/etc__adjtime
0.0 0 0.0
0
LOCAL
EOF

cat << EOF > ./templates/etc__systemd__network__10-eth-static.network
[Match]
Name=$NIC_NAME

[Network]
Address=$NIC_IP/$NIC_PREFIX
Gateway=$NIC_GATEWAY
DNS=$NIC_DNS1
EOF

cat << EOF > ./static/etc__vconsole.conf
FONT=Lat2-Terminus16 
EOF

echo '# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf

  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi

# End /etc/profile
' > ./static/etc__profile

else
	if [ -f ./templates/etc__systemd__network__10-eth-static.network ]; then
		rm -f ./templates/etc__systemd__network__10-eth-static.network
	fi
	if [ -f ./templates/etc__adjtime ]; then
		rm -f ./templates/etc__adjtime
	fi
	if [ -f ./static/etc__systemd_system_getty@tty1.service.d_noclear.conf ]; then
		rm -f ./static/etc__systemd_system_getty@tty1.service.d_noclear.conf
	fi
	if [ -f ./static/vconsole.conf ]; then
		rm -f ./static/vconsole.conf
	fi
fi
}

function build_order_sysvinit_11.0(){
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
binutils
gmp
mpfr
mpc
attr
acl
libcap
shadow
gcc
pkgconfig
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
kmod
elfutils
libffi
openssl
python
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
eudev
mandb
procps
utillinux
e2fsprogs
sysklogd
sysvinit
lfsbootscripts
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_systemd_11.0(){
cat << EOF > ./phase4/build_order.txt #_systemd-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
binutils
gmp
mpfr
mpc
attr
acl
libcap
shadow
gcc
pkgconfig
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
kmod
elfutils
libffi
openssl
python
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
systemd
dbus
mandb
procps
utillinux
e2fsprogs
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_sysvinit_11.1(){
cat << EOF > ./phase3/build_order.txt
libstdcpp GCC
gettext
bison
perl
python
texinfo
utillinux
EOF

cat << EOF > ./phase4/build_order.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
binutils
gmp
mpfr
mpc
attr
acl
libcap
shadow
gcc
pkgconfig
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
eudev
mandb
procps
utillinux
e2fsprogs
sysklogd
sysvinit
lfsbootscripts
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_systemd_11.1(){
cat << EOF > ./phase3/build_order.txt
libstdcpp GCC
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF > ./phase4/build_order.txt #_systemd-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
binutils
gmp
mpfr
mpc
attr
acl
libcap
shadow
gcc
pkgconfig
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
wheel
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
systemd
dbus
mandb
procps
utillinux
e2fsprogs
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_sysvinit_11.2(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF

cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
binutils
gmp
mpfr
mpc
attr
acl
libcap
shadow
gcc
pkgconfig
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
wheel
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
eudev
mandb
procps
utillinux
e2fsprogs
sysklogd
sysvinit
lfsbootscripts
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_systemd_11.2(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF > ./phase4/build_order.txt #_systemd-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
binutils
gmp
mpfr
mpc
attr
acl
libcap
shadow
gcc
pkgconfig
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
wheel
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
systemd
dbus
mandb
procps
utillinux
e2fsprogs
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_sysvinit_12.1(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
pkgconfig
binutils
gmp
mpfr
mpc
attr
acl
libcap
libxcrypt
shadow
gcc
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
flitcore
wheel
setuptools
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
eudev SYSTEMD
mandb
procps
utillinux
e2fsprogs
sysklogd
sysvinit
lfsbootscripts
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_systemd_12.1(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF > ./phase4/build_order.txt #_systemd-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
pkgconfig
binutils
gmp
mpfr
mpc
attr
acl
libcap
libxcrypt
shadow
gcc
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
flitcore
wheel
setuptools
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
systemd
dbus
mandb
procps
utillinux
e2fsprogs
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_sysvinit_12.2(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF > ./phase4/build_order.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
lz4
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
pkgconfig
binutils
gmp
mpfr
mpc
attr
acl
libcap
libxcrypt
shadow
gcc
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
flitcore
wheel
setuptools
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
eudev SYSTEMD
mandb
procps
utillinux
e2fsprogs
sysklogd
sysvinit
lfsbootscripts
EOF
[[ $DISK_BOOT != "0" ]] && echo "cpio" >> ./phase4/build_order.txt
cat << EOF >> ./phase4/build_order.txt
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_systemd_12.2(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF > ./phase4/build_order.txt #_systemd-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
lz4
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
pkgconfig
binutils
gmp
mpfr
mpc
attr
acl
libcap
libxcrypt
shadow
gcc
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
kmod
elfutils
libffi
python
flitcore
wheel
setuptools
ninja
meson
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
systemd
dbus
mandb
procps
utillinux
e2fsprogs
EOF
[[ $DISK_BOOT != "0" ]] && echo "cpio" >> ./phase4/build_order.txt
cat << EOF >> ./phase4/build_order.txt
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_sysvinit_12.3(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF > ./phase4/build_order.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
lz4
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
pkgconfig
binutils
gmp
mpfr
mpc
attr
acl
libcap
libxcrypt
shadow
gcc
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
elfutils
libffi
python
flitcore
wheel
setuptools
ninja
meson
kmod
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
utillinux
eudev SYSTEMD
mandb
procps
e2fsprogs
sysklogd
sysvinit
lfsbootscripts
EOF
[[ $DISK_BOOT != "0" ]] && echo "cpio" >> ./phase4/build_order.txt
cat << EOF >> ./phase4/build_order.txt
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function build_order_systemd_12.3(){
cat << EOF > ./phase3/build_order.txt
gettext
bison
perl
python
texinfo
utillinux
EOF


cat << EOF > ./phase4/build_order.txt #_systemd-$LFS_VERSION.txt
manpages
ianaetc
glibc
zlib
bzip2
xz
lz4
zstd
file
readline
m4
bc
flex
tcl
expect
dejagnu
pkgconfig
binutils
gmp
mpfr
mpc
isl
attr
acl
libcap
libxcrypt
shadow
gcc
ncurses
sed
psmisc
gettext
bison
grep
bash
libtool
gdbm
gperf
expat
inetutils
less
perl
xmlparser
intltool
autoconf
automake
openssl
elfutils
libffi
python
flitcore
wheel
setuptools
ninja
meson
kmod
coreutils
check
diffutils
gawk
findutils
groff
gzip
iproute2
kbd
libpipeline
make
patch
tar
texinfo
vim
markupsafe
jinja2
utillinux
systemd
dbus
mandb
procps
e2fsprogs
EOF
[[ $DISK_BOOT != "0" ]] && echo "cpio" >> ./phase4/build_order.txt
cat << EOF >> ./phase4/build_order.txt
linux
EOF

if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
cat << EOF >> ./phase4/build_order.txt #_sysvinit-$LFS_VERSION.txt
dosfstools
efivar
popt
efibootmgr
freetype
EOF
fi

echo "grub" >> ./phase4/build_order.txt
}

function make_clean(){
	if [ -f ./packages-$LFS_VERSION.sh ]; then
		rm -f ./packages-$LFS_VERSION.sh
	fi

	if [ -f ./phase4/build_order.txt ]; then
		rm -f ./phase4/build_order.txt
	fi
	
	if [ -f ./templates/etc__fstab ]; then
		rm -f ./templates/etc__fstab
	fi
	
	if [ -f ./static/etc__group ]; then
		rm -f ./static/etc__group
	fi
	
	if [ -f ./static/etc__passwd ]; then
		rm -f ./static/etc__passwd
	fi
	
	if [ -f ./static/etc__ld.so.conf.d__zz_i386-biarch-compat.conf ]; then
		rm -f ./static/etc__ld.so.conf.d__zz_i386-biarch-compat.conf
	fi
	
	if [ -f ./static/etc__ld.so.conf.d__zz_x32-biarch-compat.conf ]; then
		rm -f ./static/etc__ld.so.conf.d__zz_x32-biarch-compat.conf
	fi
	
	if [ -f ./templates/boot__grub__grub.cfg ]; then
		rm -f ./templates/boot__grub__grub.cfg
	fi
	
	if [ -f ./templates/etc__lfs-release ]; then
		rm -f ./templates/etc__lfs-release
	fi	
	
	if [ -f ./static/usr__sbin__mkinitramfs ]; then
		rm -f ./static/usr__sbin__mkinitramfs
	fi

	if [ -f ./static/usr__share__mkinitramfs__init.in ]; then
		rm -f ./static/usr__share__mkinitramfs__init.in
	fi	
	
	#if [ -f ./templates/etc__*_version ]; then
		rm -f ./templates/etc__*_version
	#fi
}

function make_etc_group(){
if [[ $LFSINIT == "sysvinit" ]]; then
cat << "EOF" > ./static/etc__group
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
tester:x:101:
users:x:999:
nogroup:x:65534:
EOF
fi

if [[ $LFSINIT == "systemd" ]]; then
cat << "EOF" > ./static/etc__group
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
uuidd:x:80:
systemd-oom:x:81:
wheel:x:97:
tester:x:101:
users:x:999:
nogroup:x:65534:
EOF
fi
}

function make_etc_nsswitch(){
if [[ $LFSINIT == "sysvinit" ]]; then
cat << "EOF" > ./static/etc__nsswitch.conf
passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

EOF
fi

if [[ $LFSINIT == "systemd" ]]; then
cat << "EOF" > ./static/etc__nsswitch.conf
passwd: files systemd
group: files systemd
shadow: files systemd

hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

EOF
fi
}

function make_etc_passwd(){
if [[ $LFSINIT == "sysvinit" ]]; then
cat << "EOF" > ./static/etc__passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
tester:x:101:101::/home/tester:/bin/bash
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF
fi

if [[ $LFSINIT == "systemd" ]]; then
cat << "EOF" > ./static/etc__passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false
systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false
tester:x:101:101::/home/tester:/bin/bash
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF
fi
}

function make_fstab(){
if [[ $LFSINIT == "systemd" ]]; then
cat << EOF > ./templates/etc__fstab
# Begin /etc/fstab

# file system		mount-point	type	options							dump	fsck
#														order

LABEL=$LFSROOTLABEL	/		$LFS_FS	defaults						1	1
EOF
	[[ $DISK_BOOT != 0 ]] && echo 'LABEL=$LFSBOOTLABEL		/boot		$LFS_FS	defaults						1	1' >> ./templates/etc__fstab
	if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]] && [[ $DISK_EFI != 0 ]];  then echo 'LABEL=$LFSEFILABEL		/boot/efi	vfat	codepage=437,iocharset=iso8859-1			0	1' >> ./templates/etc__fstab; fi
	if [[ $DISK_SWAP != "false" ]] || [[ $DISK_SWAP != 0 ]];  then echo 'LABEL=$LFSSWAPLABEL	swap		swap	pri=1							0	0' >> ./templates/etc__fstab; fi
	echo "" >> ./templates/etc__fstab
	echo "# End /etc/fstab" >> ./templates/etc__fstab

fi

if [[ $LFSINIT == "sysvinit" ]]; then
cat << "EOF" > ./templates/etc__fstab
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

LABEL=$LFSROOTLABEL /                        $LFS_FS defaults             1   1
PARTUUID=$SWAP_UUID      swap           swap     pri=1               0     0
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0
EOF
[[ $FIRMWARE == "UEFI" ]] && echo "efivarfs /sys/firmware/efi/efivars efivarfs defaults 0 0" >> ./templates/etc__fstab
cat << EOF >> ./templates/etc__fstab

# End /etc/fstab
EOF
fi

if [[ $LFSINIT == "sysvinit" ]] && [[ $LFS_VERSION == "11.2" ]]; then
cat << "EOF" > ./templates/etc__fstab
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

LABEL=$LFSROOTLABEL /         $LFS_FS defaults          1     1
/dev/sda2      swap           swap     pri=1               0     0
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0

# End /etc/fstab
EOF
fi


}

function make_grub(){
if [[ $LFS_VERSION == "11.2" ]]; then
cat << "EOF" > ./templates/boot__grub__grub.cfg
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2

menuentry "$GRUB_ENTRY" {
  search --no-floppy --label $LFSBOOTLABEL --set=root
  linux   /boot/vmlinuz-$KERNELVERS rootwait root=PARTUUID=$LFSPARTUUID ro
EOF
[ $DISK_BOOT -ne 0 ] && echo "  initrd /initrd.img-$KERNELVERS" >> ./templates/boot__grub__grub.cfg
cat << "EOF" >> ./templates/boot__grub__grub.cfg
}

EOF
fi

if [[ $LFS_VERSION == "12.2" ]] || [[ $LFS_VERSION == "12.3" ]]; then
cat << "EOF" > ./templates/boot__grub__grub.cfg
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2

EOF
[[ $FIRMWARE == "UEFI" ]] && echo "insmod all_video" >> ./templates/boot__grub__grub.cfg
[[ $FIRMWARE == "UEFI" ]] && echo "if loadfont /boot/grub/fonts/unicode.pf2; then" >> ./templates/boot__grub__grub.cfg
[[ $FIRMWARE == "UEFI" ]] && echo "  terminal_output gfxterm" >> ./templates/boot__grub__grub.cfg
[[ $FIRMWARE == "UEFI" ]] && echo "fi" >> ./templates/boot__grub__grub.cfg
cat << "EOF" >> ./templates/boot__grub__grub.cfg

menuentry "$GRUB_ENTRY" {
  search --no-floppy --label $LFSBOOTLABEL --set=root
EOF
if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]] && [[ $DISK_BOOT == 0 ]]; then 
	echo '  linux   /boot/$BZIMAGE rootwait root=PARTUUID=$LFSPARTUUID ro' >> ./templates/boot__grub__grub.cfg
else
	echo '  linux   /$BZIMAGE rootwait root=PARTUUID=$LFSPARTUUID ro' >> ./templates/boot__grub__grub.cfg
fi
[ $DISK_BOOT -ne 0 ] && echo "  initrd /initrd.img-$KERNELVERS" >> ./templates/boot__grub__grub.cfg
#echo "DISK_BOOT=$DISK_BOOT"

echo "}" >> ./templates/boot__grub__grub.cfg

[[ $FIRMWARE == "UEFI" ]] && echo 'menuentry "Firmware Setup" {' >> ./templates/boot__grub__grub.cfg
[[ $FIRMWARE == "UEFI" ]] && echo "  fwsetup" >> ./templates/boot__grub__grub.cfg
[[ $FIRMWARE == "UEFI" ]] && echo "}" >> ./templates/boot__grub__grub.cfg

fi
}

function make_lfs_release(){
cat << "EOF" > ./templates/etc__"$OS_ID"_version
$OS_VERSION

EOF
}

function make_packages(){
	mapfile -t wget_array < $FILENAME

	if [ -f ./packages-$LFS_VERSION.sh ]; then
		rm -f ./packages-$LFS_VERSION.sh
	fi

	touch ./packages-$LFS_VERSION.sh

	i=0
	while read line
	do 
		wget_array[$i]="$line"
		i=$((i+1))
	done < $FILENAME

	PKG_COUNT=$(cat $FILENAME | wc -l)

	for ((i=0;i!=$PKG_COUNT;i++)); do
		# This is before I knew about basename command
		FIELD_COUNT=$(($(echo ${wget_array[$i]} | grep -o "/" | wc -l)+1))
		FIELD_NAME=$(echo ${wget_array[$i]} | cut -d "/" -f $FIELD_COUNT)
		FIELD_NAME_COUNT=$(echo $FIELD_NAME | grep -o "-" | wc -l )
		
		# xyz-1.2 -> xyz
		if [[ $FIELD_NAME_COUNT == 1 ]]; then
			FIELD_NAME=$(echo $FIELD_NAME | cut -d "-" -f 1 )
		fi
		
		# xyz-abc-1.2 -> xyzabc
		if [[ $FIELD_NAME_COUNT == 2 ]]; then
			FIELD_NAME1=$(echo $FIELD_NAME | cut -d "-" -f 1 )
			FIELD_NAME2=$(echo $FIELD_NAME | cut -d "-" -f 2 )
			FIELD_NAME=$FIELD_NAME1$FIELD_NAME2
		fi
		
		# 
		if [[ $FIELD_NAME_COUNT == 3 ]]; then
			FIELD_NAME=$(echo $FIELD_NAME | cut -d "-" -f 1 )
		fi		
		
		# lower to upper
		FIELD_NAME=$(echo $FIELD_NAME | tr a-z A-Z)
		
		# Exceptions to naming
		if [[ $(echo $FIELD_NAME | grep EXPECT) ]]; then
			FIELD_NAME=EXPECT
		fi
		
		if [[ $(echo $FIELD_NAME | grep FLIT_CORE) ]]; then
			FIELD_NAME=FLITCORE
		fi
		
		if [[ $(echo $FIELD_NAME | grep NCURSES) ]]; then
			FIELD_NAME=NCURSES
		fi
		
		if [[ $(echo $FIELD_NAME | grep PKGCONF) ]]; then
			FIELD_NAME=PKGCONFIG
		fi
		
		if [[ $(echo $FIELD_NAME | grep PYTHON) ]] && [[ $(echo ${wget_array[$i]} | grep Python) ]]; then
			FIELD_NAME=PYTHON
		fi
		
		if [[ $(echo $FIELD_NAME | grep PYTHON) ]] && [[ $(echo ${wget_array[$i]} | grep html) ]]; then
			FIELD_NAME=PYTHONDOCS
		fi

		if [[ $(echo $FIELD_NAME | grep PROCPSNG) ]]; then
			FIELD_NAME=PROCPS
		fi

		if [[ $(echo $FIELD_NAME | grep SYSTEMD) ]]; then
			FIELD_NAME=SYSTEMD
		fi
		
		if [[ $(echo $FIELD_NAME | grep SYSTEMD) ]] && [[ $(echo ${wget_array[$i]} | grep pages) ]]; then
			FIELD_NAME=SYSTEMDDOCS
		fi

		if [[ $(echo $FIELD_NAME | grep TCL) ]] && [[ $(echo ${wget_array[$i]} | grep src) ]]; then
			FIELD_NAME=TCL
		fi
		
		if [[ $(echo $FIELD_NAME | grep TCL) ]] && [[ $(echo ${wget_array[$i]} | grep html) ]]; then
			FIELD_NAME=TCLDOCS
		fi

		if [[ $(echo $FIELD_NAME | grep TZDATA) ]]; then
			FIELD_NAME=TZDATA
		fi
		
		if [[ $(echo $FIELD_NAME | grep coreutils) ]] && [[ $(echo ${wget_array[$i]} | grep chmod) ]]; then
			FIELD_NAME=COREUTILS_CHMOD
		fi
		
		if [[ $(echo $FIELD_NAME | grep coreutils) ]] && [[ $(echo ${wget_array[$i]} | grep i18n) ]]; then
			FIELD_NAME=COREUTILS
		fi
		
		if [[ $(echo ${wget_array[$i]} | grep patch) ]] && ! [[ $(echo $FIELD_NAME | grep PATCH) ]]; then
			echo "export PATCH_$FIELD_NAME=${wget_array[$i]}" >> ./packages-$LFS_VERSION.sh
		else
			echo "export PKG_$FIELD_NAME=${wget_array[$i]}" >> ./packages-$LFS_VERSION.sh
		fi
	done
	
	sed -i 's/\r//g' ./packages-$LFS_VERSION.sh
}

function make_usr_sbin_mkinitramfs(){
if [[ $DISK_BOOT != "0" ]]; then
cat << "EOF" > ./static/usr__sbin__mkinitramfs
#!/bin/bash
# This file based in part on the mkinitramfs script for the LFS LiveCD
# written by Alexander E. Patrakov and Jeremy Huntwork.

copy()
{
  local file

  if [ "$2" = "lib" ]; then
    file=$(PATH=/usr/lib type -p $1)
  else
    file=$(type -p $1)
  fi

  if [ -n "$file" ] ; then
    cp $file $WDIR/usr/$2
  else
    echo "Missing required file: $1 for directory $2"
    rm -rf $WDIR
    exit 1
  fi
}

if [ -z $1 ] ; then
  INITRAMFS_FILE=initrd.img-no-kmods
else
  KERNEL_VERSION=$1
  INITRAMFS_FILE=initrd.img-$KERNEL_VERSION
fi

if [ -n "$KERNEL_VERSION" ] && [ ! -d "/usr/lib/modules/$1" ] ; then
  echo "No modules directory named $1"
  exit 1
fi

printf "Creating $INITRAMFS_FILE... "

binfiles="sh cat cp dd killall ls mkdir mknod mount "
binfiles="$binfiles umount sed sleep ln rm uname"
binfiles="$binfiles readlink basename"

# Systemd installs udevadm in /bin. Other udev implementations have it in /sbin
if [ -x /usr/bin/udevadm ] ; then binfiles="$binfiles udevadm"; fi

sbinfiles="modprobe blkid switch_root"

# Optional files and locations
for f in mdadm mdmon udevd udevadm; do
  if [ -x /usr/sbin/$f ] ; then sbinfiles="$sbinfiles $f"; fi
done

# Add lvm if present (cannot be done with the others because it
# also needs dmsetup
if [ -x /usr/sbin/lvm ] ; then sbinfiles="$sbinfiles lvm dmsetup"; fi

unsorted=$(mktemp /tmp/unsorted.XXXXXXXXXX)

DATADIR=/usr/share/mkinitramfs
INITIN=init.in

# Create a temporary working directory
WDIR=$(mktemp -d /tmp/initrd-work.XXXXXXXXXX)

# Create base directory structure
mkdir -p $WDIR/{dev,run,sys,proc,usr/{bin,lib/{firmware,modules},sbin}}
mkdir -p $WDIR/etc/{modprobe.d,udev/rules.d}
touch $WDIR/etc/modprobe.d/modprobe.conf
ln -s usr/bin  $WDIR/bin
ln -s usr/lib  $WDIR/lib
ln -s usr/sbin $WDIR/sbin
ln -s lib      $WDIR/lib64

# Create necessary device nodes
mknod -m 640 $WDIR/dev/console c 5 1
mknod -m 664 $WDIR/dev/null    c 1 3

# Install the udev configuration files
if [ -f /etc/udev/udev.conf ]; then
  cp /etc/udev/udev.conf $WDIR/etc/udev/udev.conf
fi

for file in $(find /etc/udev/rules.d/ -type f) ; do
  cp $file $WDIR/etc/udev/rules.d
done

# Install any firmware present
cp -a /usr/lib/firmware $WDIR/usr/lib

# Copy the RAID configuration file if present
if [ -f /etc/mdadm.conf ] ; then
  cp /etc/mdadm.conf $WDIR/etc
fi

# Install the init file
install -m0755 $DATADIR/$INITIN $WDIR/init

if [  -n "$KERNEL_VERSION" ] ; then
  if [ -x /usr/bin/kmod ] ; then
    binfiles="$binfiles kmod"
  else
    binfiles="$binfiles lsmod"
    sbinfiles="$sbinfiles insmod"
  fi
fi

# Install basic binaries
for f in $binfiles ; do
  ldd /usr/bin/$f | sed "s/\t//" | cut -d " " -f1 >> $unsorted
  copy /usr/bin/$f bin
done

for f in $sbinfiles ; do
  ldd /usr/sbin/$f | sed "s/\t//" | cut -d " " -f1 >> $unsorted
  copy $f sbin
done

# Add udevd libraries if not in /usr/sbin
if [ -x /usr/lib/udev/udevd ] ; then
  ldd /usr/lib/udev/udevd | sed "s/\t//" | cut -d " " -f1 >> $unsorted
elif [ -x /usr/lib/systemd/systemd-udevd ] ; then
  ldd /usr/lib/systemd/systemd-udevd | sed "s/\t//" | cut -d " " -f1 >> $unsorted
fi

# Add module symlinks if appropriate
if [ -n "$KERNEL_VERSION" ] && [ -x /usr/bin/kmod ] ; then
  ln -s kmod $WDIR/usr/bin/lsmod
  ln -s kmod $WDIR/usr/bin/insmod
fi

# Add lvm symlinks if appropriate
# Also copy the lvm.conf file
if  [ -x /usr/sbin/lvm ] ; then
  ln -s lvm $WDIR/usr/sbin/lvchange
  ln -s lvm $WDIR/usr/sbin/lvrename
  ln -s lvm $WDIR/usr/sbin/lvextend
  ln -s lvm $WDIR/usr/sbin/lvcreate
  ln -s lvm $WDIR/usr/sbin/lvdisplay
  ln -s lvm $WDIR/usr/sbin/lvscan

  ln -s lvm $WDIR/usr/sbin/pvchange
  ln -s lvm $WDIR/usr/sbin/pvck
  ln -s lvm $WDIR/usr/sbin/pvcreate
  ln -s lvm $WDIR/usr/sbin/pvdisplay
  ln -s lvm $WDIR/usr/sbin/pvscan

  ln -s lvm $WDIR/usr/sbin/vgchange
  ln -s lvm $WDIR/usr/sbin/vgcreate
  ln -s lvm $WDIR/usr/sbin/vgscan
  ln -s lvm $WDIR/usr/sbin/vgrename
  ln -s lvm $WDIR/usr/sbin/vgck
  # Conf file(s)
  cp -a /etc/lvm $WDIR/etc
fi

# Install libraries
sort $unsorted | uniq | while read library ; do
# linux-vdso and linux-gate are pseudo libraries and do not correspond to a file
# libsystemd-shared is in /lib/systemd, so it is not found by copy, and
# it is copied below anyway
  if [[ "$library" == linux-vdso.so.1 ]] ||
     [[ "$library" == linux-gate.so.1 ]] ||
     [[ "$library" == libsystemd-shared* ]]; then
    continue
  fi

  copy $library lib
done

if [ -d /usr/lib/udev ]; then
  cp -a /usr/lib/udev $WDIR/usr/lib
fi
if [ -d /usr/lib/systemd ]; then
  cp -a /usr/lib/systemd $WDIR/usr/lib
fi
if [ -d /usr/lib/elogind ]; then
  cp -a /usr/lib/elogind $WDIR/usr/lib
fi

# Install the kernel modules if requested
if [ -n "$KERNEL_VERSION" ]; then
  find \
     /usr/lib/modules/$KERNEL_VERSION/kernel/{crypto,fs,lib}                      \
     /usr/lib/modules/$KERNEL_VERSION/kernel/drivers/{block,ata,nvme,md,firewire} \
     /usr/lib/modules/$KERNEL_VERSION/kernel/drivers/{scsi,message,pcmcia,virtio} \
     /usr/lib/modules/$KERNEL_VERSION/kernel/drivers/usb/{host,storage}           \
     -type f 2> /dev/null | cpio --make-directories -p --quiet $WDIR

  cp /usr/lib/modules/$KERNEL_VERSION/modules.{builtin,order} \
            $WDIR/usr/lib/modules/$KERNEL_VERSION
  if [ -f /usr/lib/modules/$KERNEL_VERSION/modules.builtin.modinfo ]; then
    cp /usr/lib/modules/$KERNEL_VERSION/modules.builtin.modinfo \
            $WDIR/usr/lib/modules/$KERNEL_VERSION
  fi

  depmod -b $WDIR $KERNEL_VERSION
fi

( cd $WDIR ; find . | cpio -o -H newc --quiet | gzip -9 ) > $INITRAMFS_FILE

# Prepare early loading of microcode if available
if ls /usr/lib/firmware/intel-ucode/* >/dev/null 2>&1 ||
   ls /usr/lib/firmware/amd-ucode/*   >/dev/null 2>&1; then

# first empty WDIR to reuse it
  rm -r $WDIR/*

  DSTDIR=$WDIR/kernel/x86/microcode
  mkdir -p $DSTDIR

  if [ -d /usr/lib/firmware/amd-ucode ]; then
    cat /usr/lib/firmware/amd-ucode/microcode_amd*.bin > $DSTDIR/AuthenticAMD.bin
  fi

  if [ -d /usr/lib/firmware/intel-ucode ]; then
    cat /usr/lib/firmware/intel-ucode/* > $DSTDIR/GenuineIntel.bin
  fi

  ( cd $WDIR; find . | cpio -o -H newc --quiet ) > microcode.img
  cat microcode.img $INITRAMFS_FILE > tmpfile
  mv tmpfile $INITRAMFS_FILE
  rm microcode.img
fi

# Remove the temporary directories and files
rm -rf $WDIR $unsorted
printf "done.\n"
EOF
#chmod 0755 $LFS/usr/sbin/mkinitramfs
fi
}

function make_usr_share_mkinitramfs_init(){
if [[ $DISK_BOOT != "0" ]]; then
mkdir -p $LFS/usr/share/mkinitramfs
cat << "EOF" > ./static/usr__share__mkinitramfs__init.in
#!/bin/sh

PATH=/usr/bin:/usr/sbin
export PATH

problem()
{
   printf "Encountered a problem!\n\nDropping you to a shell.\n\n"
   sh
}

no_device()
{
   printf "The device %s, which is supposed to contain the\n" $1
   printf "root file system, does not exist.\n"
   printf "Please fix this problem and exit this shell.\n\n"
}

no_mount()
{
   printf "Could not mount device %s\n" $1
   printf "Sleeping forever. Please reboot and fix the kernel command line.\n\n"
   printf "Maybe the device is formatted with an unsupported file system?\n\n"
   printf "Or maybe filesystem type autodetection went wrong, in which case\n"
   printf "you should add the rootfstype=... parameter to the kernel command line.\n\n"
   printf "Available partitions:\n"
}

do_mount_root()
{
   mkdir /.root
   [ -n "$rootflags" ] && rootflags="$rootflags,"
   rootflags="$rootflags$ro"

   case "$root" in
      /dev/*    ) device=$root ;;
      UUID=*    ) eval $root; device="/dev/disk/by-uuid/$UUID" ;;
      PARTUUID=*) eval $root; device="/dev/disk/by-partuuid/$PARTUUID" ;;
      LABEL=*   ) eval $root; device="/dev/disk/by-label/$LABEL" ;;
      ""        ) echo "No root device specified." ; problem ;;
   esac

   while [ ! -b "$device" ] ; do
       no_device $device
       problem
   done

   if ! mount -n -t "$rootfstype" -o "$rootflags" "$device" /.root ; then
       no_mount $device
       cat /proc/partitions
       while true ; do sleep 10000 ; done
   else
       echo "Successfully mounted device $root"
   fi
}

do_try_resume()
{
   case "$resume" in
      UUID=* ) eval $resume; resume="/dev/disk/by-uuid/$UUID"  ;;
      LABEL=*) eval $resume; resume="/dev/disk/by-label/$LABEL" ;;
   esac

   if $noresume || ! [ -b "$resume" ]; then return; fi

   ls -lH "$resume" | ( read x x x x maj min x
       echo -n ${maj%,}:$min > /sys/power/resume )
}

init=/sbin/init
root=
rootdelay=
rootfstype=auto
ro="ro"
rootflags=
device=
resume=
noresume=false

mount -n -t devtmpfs devtmpfs /dev
mount -n -t proc     proc     /proc
mount -n -t sysfs    sysfs    /sys
mount -n -t tmpfs    tmpfs    /run

read -r cmdline < /proc/cmdline

for param in $cmdline ; do
  case $param in
    init=*      ) init=${param#init=}             ;;
    root=*      ) root=${param#root=}             ;;
    rootdelay=* ) rootdelay=${param#rootdelay=}   ;;
    rootfstype=*) rootfstype=${param#rootfstype=} ;;
    rootflags=* ) rootflags=${param#rootflags=}   ;;
    resume=*    ) resume=${param#resume=}         ;;
    noresume    ) noresume=true                   ;;
    ro          ) ro="ro"                         ;;
    rw          ) ro="rw"                         ;;
  esac
done

# udevd location depends on version
if [ -x /sbin/udevd ]; then
  UDEVD=/sbin/udevd
elif [ -x /lib/udev/udevd ]; then
  UDEVD=/lib/udev/udevd
elif [ -x /lib/systemd/systemd-udevd ]; then
  UDEVD=/lib/systemd/systemd-udevd
else
  echo "Cannot find udevd nor systemd-udevd"
  problem
fi

${UDEVD} --daemon --resolve-names=never
udevadm trigger
udevadm settle

if [ -f /etc/mdadm.conf ] ; then mdadm -As                       ; fi
if [ -x /sbin/vgchange  ] ; then /sbin/vgchange -a y > /dev/null ; fi
if [ -n "$rootdelay"    ] ; then sleep "$rootdelay"              ; fi

do_try_resume # This function will not return if resuming from disk
do_mount_root

killall -w ${UDEVD##*/}

exec switch_root /.root "$init" "$@"
EOF
fi
}

function main(){
	make_clean
	
	# Input wget-list
	if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
		local FILENAME=./wget-lists/wget-list-$LFS_VERSION-uefi
	fi
		if [[ $FIRMWARE == "BIOS" ]] || [[ $FIRMWARE == "bios" ]]; then
		local FILENAME=./wget-lists/wget-list-$LFS_VERSION
	fi

	if ! [ -f $FILENAME ]; then
		echo "Error: File ../wget-lists/$FILENAME was not found"
		exit 1
	fi

	if ! [ -d ./testlogs ]; then
		mkdir -p ./testlogs
	fi

	if ! [ -d $LFS ]; then
		mkdir -p $LFS
	fi

	# Make Phase 4 build_order
	# Supported Version Detection
	# Looks to see if a function exsists for the selected otpions
	HIT=0
	if [[ '$(declare -fF build_order_sysvinit_"$LFS_VERSION")' ]] && [[ $LFSINIT == "sysvinit" ]]; then
		build_order_sysvinit_"$LFS_VERSION"
		HIT=1
	fi
	if [[ '$(declare -fF build_order_systemd_"$LFS_VERSION")' ]] && [[ $LFSINIT == "systemd" ]]; then
		build_order_systemd_"$LFS_VERSION"
		HIT=1
	fi
	
	if [[ $HIT == 0 ]]; then
		echo "Error: Unsupported LFS Version Detected"
		exit 1
	fi

	config_sysvinit
	config_systemd
	make_etc_group
	make_etc_nsswitch
	make_etc_passwd
	make_fstab
	make_grub	
	make_lfs_release
	make_packages
	make_usr_sbin_mkinitramfs
	make_usr_share_mkinitramfs_init
}

# Run Main Program
main
