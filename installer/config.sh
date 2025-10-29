# #######################
# LFS Installer Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~

FULLPATH=$(cd $(dirname -- $0) && pwd)
export LFS_IMG=$FULLPATH/dsl_sq-systemd-12.4-multilib.tar.gz

# System Settings
export LFSROOTLABEL=DSL2_ROOT
export LFSBOOTLABEL=DSL2_BOOT
export LFSEFILABEL=DSL2_EFI
export LFSSWAPLABEL=DSL2_SWAP
export LFS_FS=ext4
export FIRMWARE=UEFI	# BIOS, UEFI

# Following is asking for in GB
export DISK_SWAP=8	# Optional
export DISK_BOOT=4	# Optional
export DISK_EFI=1	# Ignored if $FIRMWARE is not UEFI

export INSTALL_MOUNT=$FULLPATH/mnt/install
export COPY_INSTALLER=true