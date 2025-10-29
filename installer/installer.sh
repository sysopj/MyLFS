#!/usr/bin/env bash
set -e

# #########
# Functions
# ~~~~~~~~~

#DSL Welcome
function welcome() {
	cols=$(tput cols)
	#echo "Termianl columns: $cols"
	local TEST=false
	
	[[ $cols -gt "131" ]] && welcome1 && TEST=true
	[[ $TEST == false ]] && [[ $cols -gt "100" ]] && welcome2 && TEST=true
	[[ $TEST == false ]] && welcome3
	
	echo
}

function welcome1() {
	#http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=DillonSocietyLabs
	clear
	cat <<EOF
Welcome to the

██████╗ ██╗██╗     ██╗      ██████╗ ███╗   ██╗███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗██╗      █████╗ ██████╗ ███████╗
██╔══██╗██║██║     ██║     ██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝██║     ██╔══██╗██╔══██╗██╔════╝
██║  ██║██║██║     ██║     ██║   ██║██╔██╗ ██║███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝ ██║     ███████║██████╔╝███████╗
██║  ██║██║██║     ██║     ██║   ██║██║╚██╗██║╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝  ██║     ██╔══██║██╔══██╗╚════██║
██████╔╝██║███████╗███████╗╚██████╔╝██║ ╚████║███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║   ███████╗██║  ██║██████╔╝███████║
╚═════╝ ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝

                                        My Linux From Scratch Install Script.


*Inspired by Kyle Glaws' MyLFS script on github*
    
EOF
}

function welcome2() {
	#http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=DillonSocietyLabs
	clear
	cat <<EOF
Welcome to the

██████╗ ██╗██╗     ██╗      ██████╗ ███╗   ██╗███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗
██╔══██╗██║██║     ██║     ██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝
██║  ██║██║██║     ██║     ██║   ██║██╔██╗ ██║███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝ 
██║  ██║██║██║     ██║     ██║   ██║██║╚██╗██║╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝  
██████╔╝██║███████╗███████╗╚██████╔╝██║ ╚████║███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║   
╚═════╝ ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝   

██╗      █████╗ ██████╗ ███████╗
██║     ██╔══██╗██╔══██╗██╔════╝
██║     ███████║██████╔╝███████╗
██║     ██╔══██║██╔══██╗╚════██║
███████╗██║  ██║██████╔╝███████║
╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝						
				  
                                        My Linux From Scratch Install Script.


*Inspired by Kyle Glaws' MyLFS script on github*
    
EOF
}

function welcome3() {
	#http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=DillonSocietyLabs
	clear
	cat <<EOF
Welcome to the

██████╗ ██╗██╗     ██╗      ██████╗ ███╗   ██╗
██╔══██╗██║██║     ██║     ██╔═══██╗████╗  ██║
██║  ██║██║██║     ██║     ██║   ██║██╔██╗ ██║
██║  ██║██║██║     ██║     ██║   ██║██║╚██╗██║ 
██████╔╝██║███████╗███████╗╚██████╔╝██║ ╚████║ 
╚═════╝ ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝  

███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗
██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝
███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝ 
╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝ 
███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║  
╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝ 

██╗      █████╗ ██████╗ ███████╗
██║     ██╔══██╗██╔══██╗██╔════╝
██║     ███████║██████╔╝███████╗
██║     ██╔══██║██╔══██╗╚════██║
███████╗██║  ██║██████╔╝███████║
╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝						
				  
                                        My Linux From Scratch Install Script.


*Inspired by Kyle Glaws' MyLFS script on github*
    
EOF
}

function usage {
cat <<EOF

Welcome to MyLFS Installer.

    WARNING: Most of the functionality in this script requires root privilages,
and involves the partitioning, mounting and unmounting of device files. Use at
your own risk.

    To install the backup file './installer --install /dev/<devname>' on the commandline. 
Be careful with that last one - it WILL destroy all partitions on the device you specify.
Script can utilize 'pv' for a progress bar on extraction, so please install.

    options:
		-V|--verbose            The script will output more information where applicable
                                (careful what you wish for).

        -n|--install            Specify the path to a block device on which to install the
                                fully built img file.

        -h|--help               Show this message.

EOF
}

# needed by FDISK_PARAM
function partition_table {
# Setup Disk Partition Table
	if [[ $FIRMWARE == "UEFI" ]]; then
	FDISK_INSTR="g       # create GPT partition table"
	fi
	if [[ $FIRMWARE == "BIOS" ]]; then
	FDISK_INSTR="o       # create DOS partition table"
	fi
}

# needed by FDISK_PARAM
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

# needed by FDISK_PARAM
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

# needed by FDISK_PARAM
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

# needed by FDISK_PARAM
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

# needed by FDISK_PARAM
function partition_save {
# Finalize changes to Disk
export FDISK_INSTR+="
w
q
"
}

# needed by format_disk
# Do the following in this order:
function FDISK_PARAM {
	partition_table		# Setup Disk Partition Table
	partition_boot_efi	# Setup EFI partition
	partition_boot		# Setup Boot partition
	partition_root		# Setup Root partition
	partition_swap		# Setup Swap partition
	partition_save		# Finalize changes to Disk
}

# needed by format_disk and common_mount
function get_LFSPARTUUID {
	local TARGET=$1

	[[ $FIRMWARE == "BIOS" ]] && local LOOP_BOOT1=($(fdisk -l $TARGET | grep "83 Linux" | cut -d " " -f 1))
	[[ $FIRMWARE == "BIOS" ]] && local LOOP_HOME1=($(fdisk -l $TARGET | grep "83 Linux" | cut -d " " -f 1))
	[[ $FIRMWARE == "BIOS" ]] && LOOP_BOOT=${LOOP_BOOT1[0]}
	[[ $FIRMWARE == "BIOS" ]] && LOOP_HOME=${LOOP_BOOT1[-1]}
	[[ $FIRMWARE == "BIOS" ]] && LOOP_SWAP=$(fdisk -l $TARGET | grep "82 Linux swap" | cut -d " " -f 1)
	[[ $FIRMWARE == "UEFI" ]] && LOOP_HOME=$(fdisk -l $TARGET | grep "Linux filesystem" | cut -d " " -f 1)
	[[ $FIRMWARE == "UEFI" ]] && LOOP_EFI=$(fdisk -l $TARGET | grep "EFI System" | cut -d " " -f 1)
	[[ $FIRMWARE == "UEFI" ]] && LOOP_BOOT=$(fdisk -l $TARGET | grep "BIOS boot" | cut -d " " -f 1)
	[[ $FIRMWARE == "UEFI" ]] && LOOP_SWAP=$(fdisk -l $TARGET | grep "swap" | cut -d " " -f 1)
	
	export LFSPARTUUID=""
    while [ -z "$LFSPARTUUID" ]
    do
        # sometimes it takes a few seconds for the PARTUUID to be readable
        sleep 1
		local LFSPART="$(lsblk -o PARTUUID $LOOP_HOME | tail -1)"
		
		# exporting for grub.cfg
		export LFSPARTUUID=$LFSPART
    done
	
	export SWAP_UUID=$LOOP_SWAP
    while [ -z "$SWAP_UUID" ]
    do
        # sometimes it takes a few seconds for the PARTUUID to be readable
        sleep 1
		
		# exporting for grub.cfg
		export SWAP_UUID="$(lsblk -o PARTUUID $LOOP_SWAP | tail -1)"
		# echo "SWAP_UUID=$SWAP_UUID"
    done
}

# needed by install_image
function format_disk {
	local TARGET=$1
	
	echo "Wiping Device Partition Table"
	
	[[ $(lsblk $TARGET | grep "disk") ]] && DEVICE=disk || trap "echo error: DEVICE=$(echo $TARGET | grep 'disk')" ERR
	
	#echo DEVICE=$DEVICE
	
	if [[ $DEVICE == "disk" ]]; then 
		# wipe beginning of device (sometimes grub-install complains about "multiple partition labels")
		dd if=/dev/zero of=$TARGET count=2048 &> /dev/null
		
		# Find new disk size
		DISK_SIZE=$(lsblk -J --nodep $INSTALL_TGT | grep size | cut -d ":" -f 2 | cut -d "\"" -f 2 | cut -d "G" -f 1)
		if [[ $DISK_SWAP != "false" ]]; then
			# Get Swap size in Bytes
			# echo DISK_SWAP=$DISK_SWAP
			
			[[ $FIRMWARE == "UEFI" ]] && DISK_ROOT_TMP=$(subtract $DISK_SIZE $DISK_BOOT)
			[[ $FIRMWARE == "UEFI" ]] && DISK_ROOT_TMP=$(subtract $DISK_ROOT_TMP $DISK_EFI)
			DISK_ROOT=$(subtract $DISK_ROOT_TMP $DISK_SWAP)

			#If there is a decimanl, the G is not added.
			DISK_ROOT=$( echo $DISK_ROOT | cut -d \. -f 1)
			#echo DISK_ROOT=$DISK_ROOT
			
			# Generate new FDISK_INSTR
			FDISK_PARAM
		fi
		
	    # partition the device.
		# remove spaces and comments
		echo "Partitioning Device"
		#FDISK_INSTR=$(echo "$FDISK_INSTR" | sed 's/ *#.*//')
		FDISK_INSTR=$(echo "$FDISK_INSTR" | sed 's/\s*\([\+0-9a-zA-Z]*\).*/\1/')
		
		if ! echo "$FDISK_INSTR" | fdisk $INSTALL_TGT |& { $VERBOSE && cat || cat > /dev/null; }
		then
			echo "ERROR: failed to format $INSTALL_TGT. Consider manually clearing $INSTALL_TGT's parition table."
			exit
		fi

		trap "echo 'install failed.' && unmount_image && exit 1" ERR
	fi
	
	set +e
	trap - ERR
	set -e
	
	get_LFSPARTUUID $TARGET
	
	# setup root partition
	echo "formatting BOOT..."
    
	trap "echo 'Formating BOOT failed' && unmount_image && exit 1" ERR
	
	[[ $DISK_BOOT != 0 ]] && mkfs -t $LFS_FS $LOOP_BOOT &> /dev/null
	
	echo "formatting ROOT..."
	
	trap "echo 'Formating ROOT failed' && unmount_image && exit 1" ERR
	mkfs -t $LFS_FS $LOOP_HOME &> /dev/null
	
	echo "formatting SWAP..."
	
	trap "echo 'Formating SWAP failed' && unmount_image && exit 1" ERR
	
	if [[ $DISK_SWAP != "false" ]] || [[ $DISK_SWAP != 0 ]]; then
		mkswap -L $LFSSWAPLABEL $LOOP_SWAP &> /dev/null
	fi
	
	trap "echo 'Formating EFI failed' && unmount_image && exit 1" ERR

	if [[ $FIRMWARE == "UEFI" ]] && [[ $LOOP_EFI != "" ]]; then
		echo "formatting EFI..."
		mkfs -t vfat -F 32 $LOOP_EFI &> /dev/null
	fi
	
	trap "echo 'Formating /boot failed' && unmount_image && exit 1" ERR
	
	#echo "LOOP_BOOT=$LOOP_BOOT"
	
	if [[ $FIRMWARE == "UEFI" ]] && [[ $LOOP_BOOT != "" ]]; then
		mkfs -t $LFS_FS $LOOP_BOOT &> /dev/null
	fi
	
	# Refresh disk info
	echo "Rescanning Device..."
	udevadm control --reload-rules && udevadm trigger
	
	#echo "format done"
	set +e
	trap - ERR
	set -e
}

# needed by install_image
function common_mount {
	local TARGET=$1
	
	export GRUB_TARGET=$TARGET # export for grub.sh
	
	# should only be disk
	[ $(echo $TARGET | grep "loop") ] && DEVICE=loop || DEVICE=disk

    $VERBOSE && set -x
	
	# Get if the disk is "dos" or "gpt"
	export DISKLABEL=$(fdisk -l $TARGET | grep Disklabel | cut -d ":" -f 2 | sed "s/ //g")
	# echo "FIRMWARE=$FIRMWARE"
	
	# get device name for each label
	[[ $DISKLABEL == "dos" ]] && LOOP_BOOT1=($(fdisk -l $TARGET | grep "83 Linux" | cut -d " " -f 1))
    [[ $DISKLABEL == "dos" ]] && LOOP_HOME1=($(fdisk -l $TARGET | grep "83 Linux" | cut -d " " -f 1))
	[[ $DISKLABEL == "dos" ]] && LOOP_SWAP1=($(fdisk -l $TARGET | grep "82 Linux swap" | cut -d " " -f 1))
	[[ $DISKLABEL == "dos" ]] && LOOP_BOOT=${LOOP_BOOT1[0]}
	#[[ $DISKLABEL == "dos" ]] && LOOP_HOME=${LOOP_HOME1[-1]}
	[[ $DISKLABEL == "gpt" ]] && LOOP_HOME1=$(fdisk -l $TARGET | grep "Linux filesystem" | cut -d " " -f 1)
	#[[ $DISKLABEL == "gpt" ]] && LOOP_HOME=${LOOP_HOME1[-1]}
	[[ $DISKLABEL == "gpt" ]] && LOOP_EFI=$(fdisk -l $TARGET | grep "EFI System" | cut -d " " -f 1)
	[[ $DISKLABEL == "gpt" ]] && LOOP_BOOT=$(fdisk -l $TARGET | grep "BIOS boot" | cut -d " " -f 1)
	[[ $DISKLABEL == "gpt" ]] && LABEL_BOOT=$(lsblk $LOOP_BOOT -o label | tail -1)
	[[ $DISKLABEL == "gpt" ]] && LOOP_SWAP=$(fdisk -l $TARGET | grep "swap" | cut -d " " -f 1)
	
	[[ ${#LOOP_HOME1[@]} != 1 ]] && LOOP_HOME=${LOOP_HOME1[-1]} || LOOP_HOME=$LOOP_HOME1

	echo "mounting /"
	[[ $DEVICE == "disk" ]] && mkdir -p $INSTALL_MOUNT && mount -t $LFS_FS $LOOP_HOME $INSTALL_MOUNT
	# echo $?
	
	if [[ $DISK_BOOT != 0 ]]; then
		#mkdir -p $LFS/boot
		#[[ $DEVICE == "loop" ]] && mount --mkdir -t $LFS_FS $LOOP_BOOT $LFS/boot
		#echo "[[ $DEVICE == "disk" ]] && mount --mkdir -t $LFS_FS $LOOP_BOOT $INSTALL_MOUNT/boot"
		echo "mounting /boot"
		[[ $DEVICE == "disk" ]] && mount --mkdir -t $LFS_FS $LOOP_BOOT $INSTALL_MOUNT/boot
	fi
	
	if [[ $DISKLABEL == "gpt" ]] && [[ $LOOP_EFI != "" ]]; then
		#mkdir -p $LFS/boot/efi
		#[[ $DEVICE == "loop" ]] && mount --mkdir -t vfat $LOOP_EFI -o codepage=437,iocharset=iso8859-1 $LFS/boot/efi
		echo "mounting /boot/efi"
		[[ $DEVICE == "disk" ]] && mount --mkdir -t vfat $LOOP_EFI -o codepage=437,iocharset=iso8859-1 $INSTALL_MOUNT/boot/efi
	fi
	
	# Needed for the reinit function to properly handle grub
    # exporting for grub.cfg
    get_LFSPARTUUID $TARGET
	
	export SWAP_UUID=$(lsblk -o PARTUUID $LOOP_SWAP | tail -1)
    while [ -z "$SWAP_UUID" ]
    do
        # sometimes it takes a few seconds for the PARTUUID to be readable
        sleep 1
		
		# exporting for grub.cfg
		export SWAP_UUID="$(lsblk -o PARTUUID $LOOP_SWAP | tail -1)"
		# echo "SWAP_UUID=$SWAP_UUID"
    done
	
	# Cleanup some format folders
	[ -d $LFS/boot/efi/lost+found ] && rm -rf $LFS/boot/efi/lost+found
	[ -d $LFS/boot/lost+found ] && rm -rf $LFS/boot/lost+found
	[ -d $LFS/lost+found ] && rm -rf $LFS/lost+found

    set +x
	
	udevadm control --reload-rules && udevadm trigger
	
	#echo Common Mounting Done.
}

# needed by install_image
function do_restore {
    if [ ! -f $TAR_FILE_LFS ]
    then
        echo "ERROR: $TAR_FILE_LFS not found - cannot restore."
        exit 1
    fi

    $VERBOSE && set -x
	
	local TAR_FILE_LFS=$(basename $LFS_IMG )
	
	local MYLFS_ROOT=$(pwd)
	trap unmount ERR
	set +e
	
	if [[ $VERBOSE == "true" ]] && [[ ! $(command -v pv) ]]; then
		echo "Extracting $TAR_FILE_LFS"
		echo "For a progress bar, please install 'pv'"
		echo "tar -xvzsf$MYLFS_ROOT/$TAR_FILE_LFS -C $INSTALL_MOUNT/."
		tar -xvzsf $MYLFS_ROOT/$TAR_FILE_LFS -C $INSTALL_MOUNT/.
	fi
	if [[ $VERBOSE != "true" ]] && [[ ! $(command -v pv) ]]; then
		echo "Extracting $TAR_FILE_LFS"
		#echo "For a progress bar, please install 'pv'"
		tar --checkpoint=500 --checkpoint-action=dot -xzsf $MYLFS_ROOT/$TAR_FILE_LFS -C $INSTALL_MOUNT/. && echo " "
	fi
	if [[ $VERBOSE == "true" ]] && [[ $(command -v pv) ]]; then
		echo "Extracting $TAR_FILE_LFS"
		echo "pv $MYLFS_ROOT/$TAR_FILE_LFS | tar -xzf - -C $INSTALL_MOUNT/."
		pv $MYLFS_ROOT/$TAR_FILE_LFS | tar -xzf - -C $INSTALL_MOUNT/.
	fi
	if [[ $VERBOSE != "true" ]] && [[ $(command -v pv) ]]; then
		echo "Extracting $TAR_FILE_LFS"
		pv $MYLFS_ROOT/$TAR_FILE_LFS | tar -xzf - -C $INSTALL_MOUNT/.
	fi	
	get_LFSPARTUUID $INSTALL_TGT
	
	[[ $VERBOSE == "true" ]] && echo LFSPARTUUID=$LFSPARTUUID
	
	echo "Fixing /boot/grub/grub.cfg"
	
    # make sure grub.cfg is pointing at the right drive
    sed -Ei "s/root=PARTUUID=[0-9a-z-]+/root=PARTUUID=${LFSPARTUUID}/" $INSTALL_MOUNT/boot/grub/grub.cfg	
	
	[ $DISK_BOOT != 0 ] && sed -Ei "s/search --no-floppy --label DSLsq_ROOT --set=root/search --no-floppy --label $LFSBOOTLABEL --set=root/" $INSTALL_MOUNT/boot/grub/grub.cfg	
	
	echo "Fixing /etc/fstab"
	sed -i "s/DSLsq_ROOT/$LFSROOTLABEL/"	$INSTALL_MOUNT/etc/fstab
	sed -i "s/DSL2_BOOT/$LFSBOOTLABEL/"		$INSTALL_MOUNT/etc/fstab
	sed -i "s/DSLsq_EFI/$LFSEFILABEL/"		$INSTALL_MOUNT/etc/fstab
	sed -i "s/DSLsq_SWAP/$LFSSWAPLABEL/"	$INSTALL_MOUNT/etc/fstab

	echo "Files have been restored"
}

# needed by format_disk
function subtract {
	# Simple floating subtract supports only then place and postive result

	local A="$1"
	local B="$2"
	
	if [[ $(command -v bc) ]]
	then
		local RETURN=$(subtract_bc $A $B)
	else
		local RETURN=$(subtract_bash $A $B)
	fi
	
	echo $RETURN
}
# subtract 4.1 1.9 && echo $RETURN

# needed by format_disk
function subtract_bc {
	# Simple floating subtract supports only then place and postive result

	local A="$1"
	local B="$2"
	[[ $(echo $A | grep T) != "" ]] && A=$(echo $A | cut -d \T -f 1) && A=$(echo "$A * 1024" | bc)
	[[ $(echo $B | grep T) != "" ]] && B=$(echo $B | cut -d \T -f 1) && B=$(echo "$B * 1024" | bc)
	local RETURN=$(echo "$A - $B" | bc)

	echo $RETURN
	
}
# subtract 4.1 1.9 && echo $RETURN

# needed by format_disk
function subtract_bash {
	# Simple floating subtract supports only then place and postive result

	local A="$1"
	local B="$2"
	[[ $(echo $A | grep .) == "" ]] && A="$A.0"
	[[ $(echo $B | grep .) == "" ]] && B="$B.0"
	local A1=$(echo $A | cut -d "." -f 1)
	local A2=$(echo $A | cut -d "." -f 2)
	local B1=$(echo $B | cut -d "." -f 1)
	local B2=$(echo $B | cut -d "." -f 2)

	[[ $A2 -gt 9 ]] || [[ $B2 -gt 9 ]] && echo "Doest not support 100ths place" && RETURN="-1" && return

	if [[ $(($A2-$B2)) -lt "0" ]]; then
		#echo "$A2 - $B2 = $(($A2-$B2)) aka negitive"
		A1=$(($A1-1))
		A2=$(($A2-$B2+10))
	else
		#echo "$A2 - $B2 = $(($A2-$B2)) aka not negitive"	
		A2=$(($A2-$B2))
	fi

		A1=$(($A1-$B1))

	[[ $A1 -lt 0 ]] && echo "Doest not support negitive returns" && RETURN="-1" && return
	
	local RETURN=$A1.$A2
	
	echo $RETURN
	
}
# subtract 4.1 1.9 && echo $RETURN

# needed by install_image
function unmount_image {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

    $VERBOSE && set -x

	# Fix for if an item fails and stays in the items directory.
	# This would leave the $LFS busy and can not unmount.
	cd $FULLPATH

    # unmount everything
    local MOUNTED_LOCS=$(mount | grep "$INSTALL_TGT\|$INSTALL_MOUNT")

    if [ -n "$MOUNTED_LOCS" ]
    then
		echo "$MOUNTED_LOCS" | cut -d" " -f3 | tac | xargs umount
    fi

    #set +x
}

# needed by main
function install_image {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi
	
	## Does /dev/xxx exsist?
	[[ $(lsblk | grep $(echo $INSTALL_TGT | cut -d "/" -f 3)) == "" ]] && echo "Device $INSTALL_TGT not found" && exit 1
	
	[[ $DISK_BOOT == 0 ]] && export LFSBOOTLABEL=$LFSROOTLABEL
	
	unmount_image

    local PART_PREFIX=""
    case "$(basename $INSTALL_TGT)" in
		sd[a-z])
			PART_PREFIX=""
			;;
		vd[a-z])
			PART_PREFIX=""
			;;
		nvme[0-9]n[1-9])
			PART_PREFIX="p"
			;;
		*)
			echo "ERROR: Unsupported device name '$INSTALL_TGT'."
			exit 1
			;;
    esac

	set +x
	sleep 1
    read -p "WARNING: This will delete all contents of the device '$INSTALL_TGT'. Continue? (Y/N): " CONFIRM
    if [[ $CONFIRM != [yY] && $CONFIRM != [yY][eE][sS] ]]
    then
        echo "Cancelled."
        exit
    fi
	#set -x

    echo "Installing LFS onto ${INSTALL_TGT}... "

    $VERBOSE && set -x
	
	#mkdir -p $LFS $INSTALL_MOUNT
	mkdir -p $INSTALL_MOUNT
	
	# Format target
	format_disk $INSTALL_TGT
	
	echo "Format of $INSTALL_TGT is done"
	
	common_mount $INSTALL_TGT
	
	echo "Mounting of $INSTALL_TGT is done"
	
	e2label $LOOP_HOME $LFSROOTLABEL
	if [[ $LOOP_EFI != "" ]]; then fatlabel $LOOP_EFI $LFSEFILABEL &> /dev/null; fi
		# There are differences between boot sector and its backup.
		# This is mostly harmless. Differences: (offset:original/backup)
		# 	65:01/00
		# 	Not automatically fixing this.
	if [[ $LOOP_BOOT != "" ]]; then e2label $LOOP_BOOT $LFSBOOTLABEL; fi
	udevadm control --reload-rules && udevadm trigger
	
	do_restore
	
	echo "Installing Grub. This may take a few minutes..."
	
    mount --bind /dev $INSTALL_MOUNT/dev
    mount --bind /dev/pts $INSTALL_MOUNT/dev/pts
    mount -t sysfs sysfs $INSTALL_MOUNT/sys

    if [[ $FIRMWARE == "BIOS" ]] || [[ $FIRMWARE == "bios" ]]; then
		local GRUB_CMD="grub-install $INSTALL_TGT --target i386-pc"
		$VERBOSE && echo "Installing GRUB. This may take a few minutes... " #|| echo -n "Installing GRUB. This may take a few minutes... "
		chroot $INSTALL_MOUNT /usr/bin/bash -c "$GRUB_CMD" |& cat #{ $VERBOSE && cat || cat > /dev/null; }
	fi
	
    if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
		local GRUB_CMD="grub-install $GRUB_TARGET --target=x86_64-efi --removable"
		$VERBOSE && echo "Installing GRUB efi. This may take a few minutes... " #|| echo -n "Installing GRUB. This may take a few minutes... "
		chroot $INSTALL_MOUNT /usr/bin/bash -c "$GRUB_CMD" |& cat #{ $VERBOSE && cat || cat > /dev/null; }
		source $INSTALL_MOUNT/etc/os-release # For ID
		local GRUB_CMD="grub-install $GRUB_TARGET --bootloader-id=$ID --recheck"
		$VERBOSE && echo "Installing GRUB boot. This may take a few minutes... " #|| echo -n "Installing GRUB. This may take a few minutes... "
		chroot $INSTALL_MOUNT /usr/bin/bash -c "$GRUB_CMD" |& cat #{ $VERBOSE && cat || cat > /dev/null; }
	fi

    echo "Finished Installing Grub."

    set +x

    trap unmount_image ERR
	#trap - ERR

	if [[ $COPY_INSTALLER == "true" ]] && [[ $(command -v pv) ]]; then
		echo "Copying the Installer files to $INSTALL_MOUNT/root"
		pv $LFS_IMG > $INSTALL_MOUNT/root/$(basename $LFS_IMG)
		cp installer.sh $INSTALL_MOUNT/root
		cp config.sh $INSTALL_MOUNT/root
	fi
	if [[ $COPY_INSTALLER == "true" ]] && [[ ! $(command -v pv) ]]; then
		echo "Copying the Installer files to $INSTALL_MOUNT/root"
		cp $LFS_IMG $INSTALL_MOUNT/root
		cp installer.sh $INSTALL_MOUNT/root
		cp config.sh $INSTALL_MOUNT/root
	fi
	
	echo "Unmounting $INSTALL_TGT"
    unmount_image
	rm -r $FULLPATH/mnt

    echo "Installed successfully."
}

function main {
    # Perform single operations
    [ -n "$INSTALL_TGT" ] && install_image && exit 0

    trap "echo 'build cancelled.' && cd $FULLPATH && unmount_image && exit -1" SIGINT
    trap "echo 'build failed.' && cd $FULLPATH && unmount_image && exit 1" ERR

    # unmount and detatch image
    unmount_image
	
	exit 0
}

# ###############
# Parse arguments
# ~~~~~~~~~~~~~~~

welcome

cd $(dirname $0)

echo "Loading Configs"
# import config vars
source ./config.sh

VERBOSE=false

while [ $# -gt 0 ]; do
  case $1 in
    -V|--verbose)
      VERBOSE=true
      shift
      ;;
    -n|--install)
      INSTALL_TGT="$2"
      [ -z "$INSTALL_TGT" ] && echo "ERROR: $1 missing argument." && exit 1
      shift
      shift
      ;;
    -h|--help)
      usage
      exit
      ;;	 
    *)
      echo "Unknown option $1"
      usage
      exit 1
      ;;
  esac
done

# ###########
# Start build
# ~~~~~~~~~~~

main
