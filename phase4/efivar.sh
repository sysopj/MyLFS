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

make ENABLE_DOCS=0

# As Root

make install LIBDIR=/usr/lib ENABLE_DOCS=0
# LIBDIR=/usr/lib: This option overrides the default library directory of the package (/usr/lib64, which is not used by LFS).
# ENABLE_DOCS=0: Disable the generation of man pages. Append this option after the make and make install commands if you don't need the man pages to allow building this package without mandoc-1.14.6 installed.
