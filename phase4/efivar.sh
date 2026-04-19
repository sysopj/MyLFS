# efivar
# The efivar package provides tools and libraries to manipulate EFI variables.

## Contents
# Installed Programs: efisecdb and efivar
# Installed Library: libefiboot.so, libefisec.so, and libefivar.so
# Installed Directories: /usr/include/efivar

## Short Descriptions
# efisecdb - is an utility for managing UEFI signature lists
# efivar - is a tool to manipulate UEFI variables
# libefiboot.so - is a library used by efibootmgr
# libefisec.so - is a library for managing UEFI signature lists
# libefivar.so - is a library for the manipulation of EFI variables

if [[ -f ../$(basename $PATCH_EFIVAR) ]]; then
	patch -Np1 -i ../$(basename $PATCH_EFIVAR)
fi

# GLIBC_VER=$(basename $PKG_GLIBC .tar.xz | cut -d "-" -f 2)
# GLIBC_VER_MAJ=$(echo $GLIBC_VER | cut -d "." -f 1)
# GLIBC_VER_MIN=$(echo $GLIBC_VER | cut -d "." -f 2)

# GLIB_2_43_FIX_REQ=false
# [[ $GLIBC_VER_MAJ -ge "2" ]] && [[ $GLIBC_VER_MIN -ge "43" ]] && GLIB_2_43_FIX_REQ=true
# [[ $GLIB_2_43_FIX_REQ == true ]] && patch -Np1 -i ../efivar-39-upstream_fixes-1.patch

make ENABLE_DOCS=0

# As Root

make install LIBDIR=/usr/lib ENABLE_DOCS=0
# LIBDIR=/usr/lib: This option overrides the default library directory of the package (/usr/lib64, which is not used by LFS).
# ENABLE_DOCS=0: Disable the generation of man pages. Append this option after the make and make install commands if you don't need the man pages to allow building this package without mandoc-1.14.6 installed.
