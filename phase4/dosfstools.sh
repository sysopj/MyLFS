# dosfstools
# The dosfstools package contains various utilities for use with the FAT family of file systems. 

## Contents
# Installed Programs: fatlabel, fsck.fat, and mkfs.fat

##  Short Descriptions
# fatlabel - sets or gets a MS-DOS filesystem label from a given device
# fsck.fat - checks and repairs MS-DOS filesystems
# mkfs.fat - creates an MS-DOS filesystem under Linux 

#KERNELVAR=$(uname -r)
KERNELVAR=$((basename $PKG_LINUX .tar.xz) | cut -d "-" -f 2)

# Requirement Checks
CONFIG_MSDOS_FS=false
CONFIG_VFAT_FS=false
[ $(cat /boot/config-$KERNELVAR | grep CONFIG_MSDOS_FS=y) ] || [ $(cat /boot/config-$KERNELVAR | grep CONFIG_MSDOS_FS=m) ] && CONFIG_MSDOS_FS=true
[ $(cat /boot/config-$KERNELVAR | grep CONFIG_VFAT_FS=y) ]  || [ $(cat /boot/config-$KERNELVAR | grep CONFIG_VFAT_FS=m) ] && CONFIG_VFAT_FS=true
[ ! CONFIG_MSDOS_FS ] && RETURN=169 && echo "ERROR: CONFIG_MSDOS_FS is not enabled in the kernel" && return
[ ! CONFIG_VFAT_FS ] && RETURN=169 && echo "ERROR: CONFIG_VFAT_FS is not enabled in the kernel" && return

DOSFSTOOLS_VERSION=$((basename $PKG_DOSFSTOOLS .tar.gz) | cut -d "-" -f 2)

./configure --prefix=/usr            \
            --enable-compat-symlinks \
            --mandir=/usr/share/man  \
            --docdir=/usr/share/doc/dosfstools-$DOSFSTOOLS_VERSION

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install
