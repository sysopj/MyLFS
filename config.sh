# #######################
# LFS Build Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~

#
#	Copy to customization.sh any paramaters you want to change.
#	This helps with git commits and with a stable baseline.
#

#
#	Copy to ../host.sh any network paramaters you want specific to that build enviroment.
#	This helps with development in seperate networks by team members
#

# Version
export LFS_VERSION=12.3

if [ -f ./packages-$LFS_VERSION.sh ]; then
	# Needed to pull $PKG_LINUX
	# If not present, ./mylfs will create and reload this file so it will exsist.
	source ./packages-$LFS_VERSION.sh
fi

# System Settings
export LFSROOTLABEL=LFSROOT
export LFSBOOTLABEL=LFSBOOT
export LFSEFILABEL=LFSEFI
export LFSSWAPLABEL=LFSSWAP
export LFS_FS=ext4
export LFSINIT=sysvinit
#export LFSINIT=systemd
export MULTILIB=false
#export MULTILIB=true
export FIRMWARE=BIOS
#export FIRMWARE=UEFI

#os-release
	# SystemD Welcome to $PRETTY_NAME
export OS_PRETTY_NAME="Linux From Scratch GNU/Linux"
export OS_NAME="Linux From Scratch GNU/Linux"
export OS_VERSION=$LFS_VERSION
export OS_VERSION_ID="$OS_VERSION (lfs)"
export OS_VERSION_CODENAME=lfs
export OS_ID=lfs
export OS_ID_LIKE=GNU/Linux
export OS_DISTRIB_DESCRIPTION="Linux From Scratch"
export OS_CONTACT="lfs-dev@lists.linuxfromscratch.org"
export OS_HOME_URL="https://www.lfs.org/"
export OS_SUPPORT_URL="https://www.lfs.org/support"
export OS_BUG_REPORT_URL="https://bugs.lfs.org/"
export OS_PRIVACY_POLICY_URL="https://www.lfs.org/"
export OS_CONTACT="no@where.com"
#lsb_version
export LSB_DISTRIB_ID=$OS_NAME
export LSB_DISTRIB_RELEASE=$OS_VERSION
export LSB_DISTRIB_CODENAME=$OS_VERSION_CODENAME
export LSB_DISTRIB_DESCRIPTION=$OS_PRETTY_NAME

# Grub
export KERNELVERS=$((basename $PKG_LINUX .tar.xz) | cut -d "-" -f 2)
export GRUB_ENTRY="$OS_NAME, Linux $KERNELVERS-$OS_VERSION_CODENAME-$OS_VERSION-$LFSINIT"
export BZIMAGE=vmlinuz-$KERNELVERS


# Optional Settings
export CRACKLIB_SUPPORT=false
export PAPER_SIZE=letter
#export PAPER_SIZE=A4
#export BUILD_PRECOMPILED=false

# Virtual Box Settings
# UUID can be fetched from another vdi via: "VBoxManage(.exe) showhdinfo xxx.vdi"
export MAKEVDI=false
export VDI_UUID=""	# Set for a Custom UUID

# Network Settings
export NIC_NAME=eth0
export NIC_SERVICE=ipv4-static
export NIC_IP=192.168.1.100
export NIC_GATEWAY=192.168.1.1
export NIC_PREFIX=24
export NIC_BROADCAST=192.168.1.255
export NIC_DNS1=192.168.1.1
export LFS_HOSTNAME=lfs
export LFS_DOMAIN=home.intranet
export SSH_KEY=""

# Following is asking for in GB
export DISK_ROOT=12
export DISK_SWAP=8
export DISK_BOOT=1
export DISK_EFI=1	# Ignored if $FIRMWARE is not UEFI

# If you do not want a swap:
#export DISK_SWAP=false or 0

# This will make all config files refresh every time, to save having to run ./mylfs --clean first.
# Set to true if developing the script,
# Set to false for release
export ALWAYS_REBUILD=false

FULLPATH=$(cd $(dirname -- $0) && pwd)
export PACKAGE_LIST=$FULLPATH/packages-$LFS_VERSION.sh
export PACKAGE_DIR=$FULLPATH/packages-$LFS_VERSION
export KEEP_LOGS=true
export LFS=/mnt/lfs
export INSTALL_MOUNT=$FULLPATH/mnt/install
export TESTLOG_DIR=$FULLPATH/testlogs

# So I am not always changing setting for testing and causing a git update
# These are just the previous settings updated to what I am currently doing
if [ -f customization.sh ] && [[ $CONFIG_OVERRIDE != "true" ]]; then
	source ./customization.sh
fi
if [ -f customization_override.sh ] && [[ $CONFIG_OVERRIDE == "true" ]]; then
	source ./customization_override.sh
fi

if [[ ! $SKIP_LFS_TARGETS == "true" ]] && [[ $MULTILIB == "true" ]]; then
	export LFS_TGT=x86_64-$OS_ID-linux-gnu
	export LFS_TGT32=i686-$OS_ID-linux-gnu
	export LFS_TGTX32=x86_64-$OS_ID-linux-gnux32
	export LFS_IMG=$FULLPATH/$OS_ID-$LFSINIT-$LFS_VERSION-multilib.img
	export LFS_VDI=$FULLPATH/$OS_ID-$LFSINIT-$LFS_VERSION-multilib.vdi
	export LOG_DIR=$FULLPATH/logs-$LFSINIT-$LFS_VERSION-multilib
fi
if [[ ! $SKIP_LFS_TARGETS == "true" ]] && [[ $MULTILIB == "false" ]]; then
	export LFS_TGT=$(uname -m)-$OS_ID-linux-gnu
	export LFS_IMG=$FULLPATH/$OS_ID-$LFSINIT-$LFS_VERSION.img
	export LFS_VDI=$FULLPATH/$OS_ID-$LFSINIT-$LFS_VERSION.vdi
	export LOG_DIR=$FULLPATH/logs-$LFSINIT-$LFS_VERSION
fi
#export LFS_IMG=/dev/sdb

# ###################################
# No configuration settings past here
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [[ $DISK_SWAP == "false" ]] || [[ $DISK_SWAP == 0 ]] && [[ $FIRMWARE == "BIOS" ]]; then
	export LFS_IMG_SIZE=$(($DISK_ROOT*1024*1024*1024))
else
	export LFS_IMG_SIZE=$((($DISK_ROOT+$DISK_SWAP)*1024*1024*1024))
fi
if [[ $DISK_SWAP == "false" ]] || [[ $DISK_SWAP == 0 ]] && [[ $FIRMWARE == "UEFI" ]]; then
	export LFS_IMG_SIZE=$((($DISK_BOOT+$DISK_EFI+$DISK_ROOT)*1024*1024*1024))
else
	export LFS_IMG_SIZE=$((($DISK_BOOT+$DISK_EFI+$DISK_ROOT+$DISK_SWAP)*1024*1024*1024))
fi

# configure these like `MAKEFLAGS=-j1 RUN_TESTS=true ./mylfs.sh --build-all`
export MAKEFLAGS=${MAKEFLAGS:--j$(nproc)}
export RUN_TESTS=${RUN_TESTS:-false}
export ROOT_PASSWD=${ROOT_PASSWD:-password}
export LFSHOSTNAME=${LFSHOSTNAME:-lfs}
export LFS_FQDN=$LFS_HOSTNAME.$LFS_DOMAIN

function partition_table {
# Setup Disk Partition Table
	if [[ $FIRMWARE == "UEFI" ]]; then
	FDISK_INSTR="g       # create GPT partition table"
	fi
	if [[ $FIRMWARE == "BIOS" ]]; then
	FDISK_INSTR="o       # create DOS partition table"
	fi
}

function partition_boot_efi {
# Setup EFI partition
if [[ $FIRMWARE == "UEFI" ]]; then
FDISK_INSTR+="
n       # new partition
        # default partition number
        # default partition start
+${DISK_EFI}G    # partition size
t		# Change Partition
		# Change last partition made
uefi	# Type 1 (EFI System)"
fi
}

function partition_boot {
# Setup Boot partition
if [[ $FIRMWARE == "UEFI" ]] && [[ $DISK_BOOT != 0 ]]; then
FDISK_INSTR+="
n       # new partition
        # default partition number
        # default partition start
+${DISK_BOOT}G    # partition size

t		# Change Partition
		# Change last partition made
4		# Type 4 (BIOS boot)"
fi

if [[ $FIRMWARE == "BIOS" ]] && [[ $DISK_BOOT != 0 ]]; then
FDISK_INSTR+="
n       # new partition
		# default partition type
        # default partition number
        # default partition start
+${DISK_BOOT}G    # partition size"
fi
}

function partition_root {
# Setup Root partition
if [[ $FIRMWARE == "UEFI" ]]; then
FDISK_INSTR+="
n       # new partition
        # default partition number
        # default partition start
+${DISK_ROOT}G    # partition size"
fi

# Setup Root partition
if [[ $FIRMWARE == "BIOS" ]]; then
FDISK_INSTR+="
n       # new partition
        # default partition type
        # default partition number
        # default partition start
+${DISK_ROOT}G    # partition size"
fi
}

function partition_swap {
# Setup Swap partition
if [[ $DISK_SWAP != "false" ]] && [[ $DISK_SWAP != 0 ]] && [[ $FIRMWARE == "UEFI" ]]; then
FDISK_INSTR+="
n       # new partition
        # default partition number ($LAST)
        # default partition start
        # default partition end (max)
t		# Change Partition
		# Change last partition made
swap	# Type Swap"
fi

if [[ $DISK_SWAP != "false" ]] && [[ $DISK_SWAP != 0 ]] && [[ $FIRMWARE == "BIOS" ]]; then
FDISK_INSTR+="
n       # new partition
        # default partition type
        # default partition number ($LAST)
        # default partition start
        # default partition end (max)
t		# Change Partition
		# Change last partition made
82		# Type Swap"
fi
}

function partition_save {
# Finalize changes to Disk
export FDISK_INSTR+="
w
q
"
}

# Made into a function for the install option
# Do the following in this order:
function FDISK_PARAM {
	partition_table		# Setup Disk Partition Table
	partition_boot_efi	# Setup EFI partition
	partition_boot		# Setup Boot partition
	partition_root		# Setup Root partition
	partition_swap		# Setup Swap partition
	partition_save		# Finalize changes to Disk
}
FDISK_PARAM

KEYS="MAKEFLAGS PACKAGE_LIST PACKAGE_DIR LOG_DIR KEEP_LOGS LFS LFS_TGT"\
" LFS_FS LFS_IMG LFS_IMG_SIZE ROOT_PASSWD RUN_TESTS TESTLOG_DIR LFSHOSTNAME"\
" LFSROOTLABEL LFSEFILABEL KERNELVERS FDISK_INSTR"

for KEY in $KEYS
do
    if [ -z "${!KEY}" ]
    then
        echo "ERROR: '$KEY' config is not set."
        exit 254
    fi
done

if [[ $MULTILIB == "true" ]] && [[ $DISK_ROOT -lt "11" ]]; then
	echo "Disk is too small for the current configuration"
	exit 1
fi

if [[ $MULTILIB == "false" ]] && [[ $DISK_ROOT -lt "7" ]]; then
	echo "Disk is too small for the current configuration"
	exit 1
fi

if [[ $DISK_BOOT == 0 ]]; then
	#echo "export LFSBOOTLABEL=$LFSROOTLABEL"
	export LFSBOOTLABEL=$LFSROOTLABEL
fi