source ./config.sh
source ./packages-12.2.sh
source ./extension_curl/packages.sh
source ./extension_openssh/packages.sh

# Used in update_version_list
function program_basename {
	# 
	local NEWNAME=$(basename $1)
	# Fix for tcl8.6.14-src.tar.gz
	[ $(echo $NEWNAME | grep "\-src.tar.gz") ] && NEWNAME=$(basename $1 -src.tar.gz)
	local COUNT="$(echo $NEWNAME |  grep -o '-' | wc -l)"
	
	echo NEWNAME=$NEWNAME
	echo COUNT=$COUNT
	
	if [[ $COUNT == 2 ]]; then
		local NEW_NAME_F1="$(echo $NEWNAME | cut -d "-" -f 1)"
		local NEW_NAME_F2="$(echo $NEWNAME | cut -d "-" -f 2)"
		local NEW_NAME_F3="$(echo $NEWNAME | cut -d "-" -f 3)"

		local NEWNAME="${NEW_NAME_F1}_${NEW_NAME_F2}-${NEW_NAME_F3}"
	fi

	if [[ $COUNT == 3 ]]; then
		local NEW_NAME_F1="$(echo $NEWNAME | cut -d "-" -f 1)"
		local NEW_NAME_F2="$(echo $NEWNAME | cut -d "-" -f 2)"
		local NEW_NAME_F3="$(echo $NEWNAME | cut -d "-" -f 3)"
		local NEW_NAME_F4="$(echo $NEWNAME | cut -d "-" -f 4)"

		local NEWNAME="${NEW_NAME_F1}_${NEW_NAME_F2}_${NEW_NAME_F3}-${NEW_NAME_F4}"
	fi
	
	if [[ $COUNT == 0 ]]; then
		local TEXT=${NEWNAME%%[0-9]*}
		local TEXT_COUNT=$(echo $TEXT | wc -c)
		local NUMBERS=$(echo $NEWNAME | cut -c $TEXT_COUNT-)
		local TEXT=${NEWNAME%%[0-9]*}
		
		echo TEXT_COUNT=$TEXT_COUNT
		echo NUMBERS=$NUMBERS
		echo TEXT=$TEXT
		
		local NEWNAME="$TEXT-$NUMBERS"
		echo NEWNAME=$NEWNAME
	fi
	
	PACKAGE_NAME=$NEWNAME
	[ $(echo $NEWNAME | grep .tar.xz) ] && local PACKAGE_NAME=$(basename $NEWNAME .tar.xz)
	[ $(echo $NEWNAME | grep .tar.gz) ] && local PACKAGE_NAME=$(basename $NEWNAME .tar.gz)
	[ $(echo $NEWNAME | grep .tar.bz2) ] && local PACKAGE_NAME=$(basename $NEWNAME .tar.bz2)
	[ $(echo $NEWNAME | grep .pcf.gz) ] && local PACKAGE_NAME=$(basename $NEWNAME .pcf.gz)


	export PROGRAM_NAME=$(echo $PACKAGE_NAME | cut -d "-" -f 1) 
	export PROGRAM_VERSION=$(echo $PACKAGE_NAME | cut -d "-" -f 2) 
	
	echo PROGRAM_NAME=$PROGRAM_NAME
	echo PROGRAM_VERSION=$PROGRAM_VERSION
}

# Used in complete.sh
function update_version_list {
	program_basename $1
	#description_version
	
	#echo PROGRAM_NAME=$PROGRAM_NAME
	#echo PROGRAM_VERSION=$PROGRAM_VERSION
	
	#echo EXTENSION=$EXTENSION
	#echo DESCRIPTION_INDIVIDUAL=$DESCRIPTION_INDIVIDUAL
	
	local LIST_VERSION=$PROGRAM_VERSION
	#[[ $DESCRIPTION_INDIVIDUAL == "true" ]] && local LIST_VERSION=$DESCRIPTION_VERSION
	
	touch installed_version.list
	local OLD="$(cat $LFS/etc/extension/installed_version.list | grep $PROGRAM_NAME)"
	local NEW="$PROGRAM_NAME=$LIST_VERSION"
	
	echo OLD=$OLD
	echo NEW=$NEW
	
	if [[ $OLD == "" ]]; then
		#echo ADD
		echo $NEW >> $LFS/etc/extension/installed_version.list 
	else
		#echo CHANGE
		sed -i "s/$OLD/$NEW/g" $LFS/etc/extension/installed_version.list 
	fi
	
	unset PROGRAM_NAME
	unset PROGRAM_VERSION
	unset DESCRIPTION_INDIVIDUAL
	unset DESCRIPTION_VERSION
	
}

#./mylfs --mount

[[ ! -d $LFS/root ]] && ./mylfs.sh --mount

if [[ -f $LFS/etc/extension/installed_version.list ]]
then
	echo "WARNING: installed_version.list is present. If you start from the beginning, this file will be deleted."
	[[ $BATCH == "true" ]] && CONFIRM=Y || read -p "Continue? (Y/N): " CONFIRM
	if [[ $CONFIRM == [yY] || $CONFIRM == [yY][eE][sS] ]]
	then
		rm $LFS/etc/extension/installed_version.list
		echo "done."
	else
		exit
	fi
fi

mkdir -p $LFS/etc/extension

update_version_list $PKG_ACL
update_version_list $PKG_ATTR
update_version_list $PKG_AUTOCONF
update_version_list $PKG_AUTOMAKE
update_version_list $PKG_BASH
update_version_list $PKG_BC
update_version_list $PKG_BINUTILS
update_version_list $PKG_BISON
update_version_list $PKG_BZIP2
update_version_list $PKG_CHECK
update_version_list $PKG_COREUTILS
update_version_list $PKG_DBUS
update_version_list $PKG_DEJAGNU
update_version_list $PKG_DIFFUTILS
update_version_list $PKG_E2FSPROGS
update_version_list $PKG_ELFUTILS
update_version_list $PKG_EXPAT
update_version_list $PKG_EXPECT
update_version_list $PKG_FILE
update_version_list $PKG_FINDUTILS
update_version_list $PKG_FLEX
update_version_list $PKG_FLITCORE
update_version_list $PKG_GAWK
update_version_list $PKG_GCC
update_version_list $PKG_GDBM
update_version_list $PKG_GETTEXT
update_version_list $PKG_GLIBC
update_version_list $PKG_GMP
update_version_list $PKG_GPERF
update_version_list $PKG_GREP
update_version_list $PKG_GROFF
update_version_list $PKG_GRUB
update_version_list $PKG_GZIP
update_version_list $PKG_IANAETC
update_version_list $PKG_INETUTILS
update_version_list $PKG_INTLTOOL
update_version_list $PKG_IPROUTE2
update_version_list $PKG_ISL
update_version_list $PKG_JINJA2
update_version_list $PKG_KBD
update_version_list $PKG_KMOD
update_version_list $PKG_LESS
update_version_list $PKG_LFSBOOTSCRIPTS
update_version_list $PKG_LIBCAP
update_version_list $PKG_LIBFFI
update_version_list $PKG_LIBPIPELINE
update_version_list $PKG_LIBTOOL
update_version_list $PKG_LIBXCRYPT
update_version_list $PKG_LINUX
update_version_list $PKG_LZ4
update_version_list $PKG_M4
update_version_list $PKG_MAKE
update_version_list $PKG_MANDB
update_version_list $PKG_MANPAGES
update_version_list $PKG_MARKUPSAFE
update_version_list $PKG_MESON
update_version_list $PKG_MPC
update_version_list $PKG_MPFR
update_version_list $PKG_NCURSES
update_version_list $PKG_NINJA
update_version_list $PKG_OPENSSL
update_version_list $PKG_PATCH
update_version_list $PKG_PERL
update_version_list $PKG_PKGCONFIG
update_version_list $PKG_PROCPS
update_version_list $PKG_PSMISC
update_version_list $PKG_PYTHON
update_version_list $PKG_READLINE
update_version_list $PKG_SED
update_version_list $PKG_SETUPTOOLS
update_version_list $PKG_SHADOW
update_version_list $PKG_SYSKLOGD
update_version_list $PKG_SYSTEMD
update_version_list $PKG_SYSVINIT
update_version_list $PKG_TAR
update_version_list $PKG_TCL
update_version_list $PKG_TEXINFO
update_version_list $PKG_TZDATA
update_version_list $PKG_UDEVLFS
update_version_list $PKG_UTILLINUX
update_version_list $PKG_VIM
update_version_list $PKG_WHEEL
update_version_list $PKG_XMLPARSER
update_version_list $PKG_XZ
update_version_list $PKG_ZLIB
update_version_list $PKG_ZSTD
update_version_list $PKG_EFIVAR
update_version_list $PKG_EFIBOOTMGR
update_version_list $PKG_UNIFONT
update_version_list $PKG_DOSFSTOOLS
update_version_list $PKG_POPT
update_version_list $PKG_FREETYPE
update_version_list $PKG_CURL
[[ $LFSINIT == "initv" ]] && update_version_list $PKG_BLFSBOOTSCRIPTS
[[ $LFSINIT == "systemd" ]] && update_version_list $PKG_BLFSSYSTEMD
update_version_list $PKG_OPENSSH

./mylfs --umount
