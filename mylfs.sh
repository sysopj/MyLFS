#!/usr/bin/env bash
set -e


# #########
# Functions
# ~~~~~~~~~

#DSL Welcome
function welcome() {
	#http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=DillonSocietyLabs
	clear
	local response
	cat <<EOF
Welcome to the



██████╗ ██╗██╗     ██╗      ██████╗ ███╗   ██╗███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗██╗      █████╗ ██████╗ ███████╗
██╔══██╗██║██║     ██║     ██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝██║     ██╔══██╗██╔══██╗██╔════╝
██║  ██║██║██║     ██║     ██║   ██║██╔██╗ ██║███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝ ██║     ███████║██████╔╝███████╗
██║  ██║██║██║     ██║     ██║   ██║██║╚██╗██║╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝  ██║     ██╔══██║██╔══██╗╚════██║
██████╔╝██║███████╗███████╗╚██████╔╝██║ ╚████║███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║   ███████╗██║  ██║██████╔╝███████║
╚═════╝ ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝
                                                                                                                                    



                                        Linux From Scratch Build Script.
											-x86_64 Multilib support added.
											-SysVinit support
											-SystemD support
											-12.2 support
											-12.3 support
											-12.4 support


*based on Kyle Glaws MyLFS script on github*
    
EOF
}

function usage {
cat <<EOF

Welcome to MyLFS.

    WARNING: Most of the functionality in this script requires root privilages,
and involves the partitioning, mounting and unmounting of device files. Use at
your own risk.

    If you would like to build Linux From Scratch from beginning to end, just
run the script with the '--build-all' command. Otherwise, you can build LFS one step
at a time by using the various commands outlined below. Before building anything
however, you should be sure to run the script with '--check' to verify the
dependencies on your system. If you want to install the IMG file that this
script produces onto a storage device, you can specify '--install /dev/<devname>'
on the commandline. Be careful with that last one - it WILL destroy all partitions
on the device you specify.

    options:
        -v|--version            Print the LFS version this build is based on, then exit.

        -V|--verbose            The script will output more information where applicable
                                (careful what you wish for).

        -e|--check              Output LFS dependency version information, then exit.
                                It is recommended that you run this before proceeding
                                with the rest of the build.

		--multilib              Test if your system is confiured for multilib development
		
        -b|--build-all          Run the entire script from beginning to end.

        -x|--extend             Pass in the path to a custom build extension. See the
                                'example_extension' directory for reference.

        -d|--download-packages  Download all packages into the 'packages' directory, then
                                exit.

        -i|--init               Create the .img file, partition it, setup basic directory
                                structure, then exit.

        -p|--start-phase
        -a|--start-package      Select a phase and optionally a package
                                within that phase to start building from.
                                These options are only available if the preceeding
                                phases have been completed. They should really only
                                be used when something broke during a build, and you
                                don't want to start from the beginning again.

        -o|--one-off            Only build the specified phase/package.

        -r|--resume             Continue where process was interupted.
		
        -k|--kernel-config      Optional path to kernel config file to use during linux
                                build.

        -m|--mount
        -u|--umount             These options will mount or unmount the disk image to the
                                filesystem, and then exit the script immediately.
                                You should be sure to unmount prior to running any part of
                                the build, since the image will be automatically mounted
                                and then unmounted at the end.
		
        -n|--install            Specify the path to a block device on which to install the
                                fully built img file.

        -c|--clean              This will unmount and delete the image, and clear the logs.

        --vdi                   This make a VirtualBox VDI file from the $LFS_IMG.

        --backup              	This make a $LFS_IMG.tar.gz of the location $LFS + $LOG_DIR.

        --restore              	This restores a $LFS + $LOG_DIR from a $LFS_IMG.tar.gz.
		
        --reinit              	This reruns the copy static and template files.
		
        --make_clean            Cleans the MyLFS project

        --env               	Show all variables.

        -h|--help               Show this message.
		
		--chroot				chroot into your project

EOF
}

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
		
		#if [[ $LOOP_BOOT != "" ]]; then 
		#	local LFSPART="$(lsblk -o PARTUUID $LOOP_BOOT | tail -1)"
		#else
			local LFSPART="$(lsblk -o PARTUUID $LOOP_HOME | tail -1)"
		#fi
		
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

function format_disk {
	local TARGET=$1
	
	[ $(echo $TARGET | grep "loop") ] && DEVICE=loop || DEVICE=disk 
	
	if [[ $DEVICE == "loop" ]]; then 
		echo formating $TARGET
		# partition the device.
		# remove spaces and comments from instructions
		#FDISK_INSTR=$(echo "$FDISK_INSTR" | sed 's/ *#.*//')
		FDISK_INSTR=$(echo "$FDISK_INSTR" | sed 's/\s*\([\+0-9a-zA-Z]*\).*/\1/')

		# fdisk fails to get kernel to re-read the partition table
		# so ignore non-zero exit code, and manually re-read
		trap - ERR
		set +e
		echo "$FDISK_INSTR" | fdisk $TARGET &> /dev/null
		#echo $?
		set -e
		trap "echo 'init failed.' && unmount_image && exit 3" ERR

		# reattach loop device to re-read partition table
		# sometimes it takes a few seconds for the loop device to be availible
		losetup -d $TARGET
		ERROR_NO=$?
		while [[ $ERROR_NO != 0 ]]
		do
			sleep 1
			losetup -d $TARGET
			ERROR_NO=$?
			#echo $ERROR_NO
		done
		
		# ERROR_NO=$?
		# echo "losetup -P $TARGET $LFS_IMG resulted in $ERROR_NO"
		ERROR_NO=-1
		while [[ $ERROR_NO != 0 ]]
		do
			sleep 1
			losetup -P $TARGET $LFS_IMG
			ERROR_NO=$?
			#echo $ERROR_NO
		done
	fi
	
	if [[ $DEVICE == "disk" ]]; then 
		# wipe beginning of device (sometimes grub-install complains about "multiple partition labels")
		dd if=/dev/zero of=$TARGET count=2048
		
		# Find new disk size
		DISK_SIZE=$(lsblk -J --nodep $INSTALL_TGT | grep size | cut -d ":" -f 2 | cut -d "\"" -f 2 | cut -d "G" -f 1)
		if [[ $DISK_SWAP != "false" ]]; then
			# Get Swap size in Bytes
			DISK_SWAP_B=$(($DISK_SWAP*1024*1024))

			# Convert to G with a tenths place
			DISK_SWAP_G1=$(echo $DISK_SWAP_B | cut -c 1)
			DISK_SWAP_G2=$(echo $DISK_SWAP_B | cut -c 2)		
			DISK_SWAP_G=$DISK_SWAP_G1.$DISK_SWAP_G2
			
			[[ $FIRMWARE == "UEFI" ]] && DISK_ROOT=$(subtract $DISK_SIZE $DISK_BOOT)
			[[ $FIRMWARE == "UEFI" ]] && DISK_ROOT=$(subtract $DISK_SIZE $DISK_EFI)
			
			# Set new disk root size to the tenths place
			DISK_ROOT=$(subtract $DISK_SIZE $DISK_SWAP_G)
			
			[[ $FIRMWARE == "UEFI" ]] && DISK_ROOT=$(subtract $DISK_ROOT $DISK_BOOT)
			[[ $FIRMWARE == "UEFI" ]] && DISK_ROOT=$(subtract $DISK_ROOT $DISK_EFI)
			
			#DISK_ROOT=$(subtract $DISK_SIZE $DISK_SWAP) # results in a swap short .2
			
			# Generate new FDISK_INSTR
			FDISK_PARAM
		fi
		
	    # partition the device.
		# remove spaces and comments
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
	echo "formatting..."
    
	trap "echo 'Formating BOOT failed' && unmount_image && exit 1" ERR
	
	[[ $DISK_BOOT != 0 ]] && mkfs -t $LFS_FS $LOOP_BOOT &> /dev/null
	
	trap "echo 'Formating ROOT failed' && unmount_image && exit 1" ERR
	mkfs -t $LFS_FS $LOOP_HOME &> /dev/null
	
	trap "echo 'Formating SWAP failed' && unmount_image && exit 1" ERR
	
	if [[ $DISK_SWAP != "false" ]] || [[ $DISK_SWAP != 0 ]]; then
		mkswap -L $LFSSWAPLABEL $LOOP_SWAP &> /dev/null
	fi
	
	trap "echo 'Formating EFI failed' && unmount_image && exit 1" ERR

	if [[ $FIRMWARE == "UEFI" ]] && [[ $LOOP_EFI != "" ]]; then
		mkfs -t vfat -F 32 $LOOP_EFI &> /dev/null
	fi
	
	trap "echo 'Formating /boot failed' && unmount_image && exit 1" ERR
	
	#echo "LOOP_BOOT=$LOOP_BOOT"
	
	if [[ $FIRMWARE == "UEFI" ]] && [[ $LOOP_BOOT != "" ]]; then
		mkfs -t $LFS_FS $LOOP_BOOT &> /dev/null
	fi
	
	# Refresh disk info
	#[[ $DEVICE == "disk" ]] && 
	udevadm control --reload-rules && udevadm trigger
	
	echo "format done"
	set +e
	trap - ERR
	set -e
}

function chroot_do {
	chroot "$LFS" /usr/bin/env 		\
		HOME=/root 					\
		TERM=$TERM 					\
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin 	\
		MAKEFLAGS="-j$(nproc)"      \
		TESTSUITEFLAGS="-j$(nproc)" \
		/usr/bin/bash +h -c "$1" |& { $VERBOSE && tee $LOG_FILE || cat > $LOG_FILE; }
}

function common_mount {
	local TARGET=$1
	
	export GRUB_TARGET=$TARGET # export for grub.sh
	
	[ $(echo $TARGET | grep "loop") ] && DEVICE=loop

    $VERBOSE && set -x
	
	if [[ $DEVICE == "loop" ]]; then
		echo Loop Target Detected and mounting first...
		# ERROR_NO=$?
		# echo "losetup -P $TARGET $LFS_IMG resulted in $ERROR_NO"
		ERROR_NO=-1
		while [[ $ERROR_NO != 0 ]]
		do
			sleep 1
			#echo "losetup -P $TARGET $LFS_IMG"
			losetup -P $TARGET $LFS_IMG
			ERROR_NO=$?
			#echo $ERROR_NO
		done
		
		echo Loop Target Mounted
	fi
	
	export DISKLABEL=$(fdisk -l $TARGET | grep Disklabel | cut -d ":" -f 2 | sed "s/ //g")
	# echo "FIRMWARE=$FIRMWARE"
	
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

	# When LOOP_HOME's grep is Linux, this also captures swap.  Need to filet out.
	#LOOP_HOME=$(echo $LOOP_HOME | sed 's,'"$LOOP_SWAP"',,' | sed "s/ //")

    # echo "mount -t $LFS_FS $LOOP_HOME $LFS"
	# losetup --all
	mkdir -p $LFS
	#echo "mount -t $LFS_FS $LOOP_HOME $LFS <end>"
	
	[[ $DEVICE == "loop" ]] && mount -t $LFS_FS $LOOP_HOME $LFS
	#echo "DEVICE=$DEVICE"
	[[ $DEVICE == "disk" ]] && mkdir -p $INSTALL_MOUNT && mount -t $LFS_FS $LOOP_HOME $INSTALL_MOUNT
	# echo $?
	
	#echo "LOOP_BOOT=$LOOP_BOOT"
	#echo "LOOP_EFI=$LOOP_EFI"
	
	if [[ $DISK_BOOT != 0 ]]; then
		#mkdir -p $LFS/boot
		[[ $DEVICE == "loop" ]] && mount --mkdir -t $LFS_FS $LOOP_BOOT $LFS/boot
		#echo "[[ $DEVICE == "disk" ]] && mount --mkdir -t $LFS_FS $LOOP_BOOT $INSTALL_MOUNT/boot"
		[[ $DEVICE == "disk" ]] && mount --mkdir -t $LFS_FS $LOOP_BOOT $INSTALL_MOUNT/boot
	fi
	
	if [[ $DISKLABEL == "gpt" ]] && [[ $LOOP_EFI != "" ]]; then
		#mkdir -p $LFS/boot/efi
		[[ $DEVICE == "loop" ]] && mount --mkdir -t vfat $LOOP_EFI -o codepage=437,iocharset=iso8859-1 $LFS/boot/efi
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
	
	[ -d $LFS/boot/efi/lost+found ] && rm -rf $LFS/boot/efi/lost+found
	[ -d $LFS/boot/lost+found ] && rm -rf $LFS/boot/lost+found
	[ -d $LFS/lost+found ] && rm -rf $LFS/lost+found

    set +x
	
	udevadm control --reload-rules && udevadm trigger
	
	echo Common Mounting Done.
}

function fPHASE {
	#set -x
	local FILE_NAME=$(basename $(ls $LOG_DIR/*.log) .log )
	local FIELD_COUNT=$(($(echo ${FILE_NAME} | grep -o "_" | wc -l ) + 1))
	#set -x
	export STARTPHASE=$(basename $(ls $LOG_DIR/*.log) .log | cut -d "_" -f $FIELD_COUNT | sed 's/phase//')
	#set +x
}

function fSCRIPT {
	#set -x
	export STARTPKG=$(basename $(ls $LOG_DIR/*.log) _phase"$STARTPHASE".log )
	#set +x
}

function make_clean {
	if [ -f ./templates/etc__sysconfig__ifconfig.* ]; then
		rm -f ./templates/etc__sysconfig__ifconfig.*
	fi
	if [ -f ./static/etc__profile ]; then
		rm -f ./static/etc__profile
	fi
	if [ -f ./static/etc__sysconfig__clock ]; then
		rm -f ./static/etc__sysconfig__clock
	fi
	if [ -f ./static/etc__sysconfig__console ]; then
		rm -f ./static/etc__sysconfig__console
	fi
	if [ -f ./static/etc__sysconfig__rc.site ]; then
		rm -f ./static/etc__sysconfig__rc.site
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
	#if [ -f ./templates/etc__*_version ]; then
		rm -f ./templates/etc__*_version
	#fi

	sed -i "s/export ALWAYS_REBUILD=true/export ALWAYS_REBUILD=false/g" config.sh

	rm -f packages*.sh

	if [ -f customization_override.sh ]; then
		rm -f customization_override.sh
	fi
}

function make_backup {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

    if [ ! -f $LFS_IMG ]
    then
        echo "ERROR: $LFS_IMG not found - cannot mount."
        exit 1
    fi

    $VERBOSE && set -x

    # make sure everything is unmounted first
    unmount_image

	# attach loop device
    export LOOP=$(losetup -f)

	# make sure everything is unmounted first
    unmount_image

	common_mount $LOOP
	
	local TAR_FILE_LFS=$(basename $LFS_IMG .img).tar.gz
	local TAR_FILE_LOG=$(basename $LOG_DIR).tar.gz
	
	#echo TAR_FILE_LOG=$TAR_FILE_LOG
	
	if [ -f $TAR_FILE_LFS ]; then rm -f $TAR_FILE_LFS; fi
	if [ -f $TAR_FILE_LOG ]; then rm -f $TAR_FILE_LOG; fi
	
	if [[ $VERBOSE == "true" ]]; then
		MYLFS_ROOT=$(pwd)
		pushd $LFS
			echo "MYLFS_ROOT=$MYLFS_ROOT"
			echo "tar -czf $MYLFS_ROOT/$TAR_FILE_LFS ."
			tar -cvzf $MYLFS_ROOT/$TAR_FILE_LFS .
		popd
		pushd $LOG_DIR
			echo "MYLFS_ROOT=$MYLFS_ROOT"
			echo "tar -czf $MYLFS_ROOT/$TAR_FILE_LOG ."
			tar -cvzf $MYLFS_ROOT/$TAR_FILE_LOG .
		popd
	else
		MYLFS_ROOT=$(pwd)
		pushd $LFS &> /dev/null
			tar -czf $MYLFS_ROOT/$TAR_FILE_LFS .
		popd &> /dev/null
		pushd $LOG_DIR &> /dev/null
			tar -czf $MYLFS_ROOT/$TAR_FILE_LOG .
		popd &> /dev/null
	fi
	
	unmount_image
	
	set +x
	
	exit 0
}

function do_restore {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

    if [ ! -f $LFS_IMG ]
    then
        echo "ERROR: $LFS_IMG not found - cannot mount."
        exit 1
    fi

    if [ ! -f $TAR_FILE_LFS ]
    then
        echo "ERROR: $TAR_FILE_LFS not found - cannot restore."
        exit 1
    fi

    $VERBOSE && set -x

    # make sure everything is unmounted first
    unmount_image

	# attach loop device
    export LOOP=$(losetup -f)

	common_mount $LOOP
	
	local TAR_FILE_LFS=$(basename $LFS_IMG .img).tar.gz
	local TAR_FILE_LOG=$(basename $LOG_DIR .img).tar.gz
	
	local MYLFS_ROOT=$(pwd)
	trap - ERR
	set +e
	pushd $LOG_DIR &> /dev/null
		rm -Rf *
	popd &> /dev/null
	
	if [[ $VERBOSE == "true" ]]; then
		pushd $LFS
			echo "tar -xvzsf $MYLFS_ROOT/$TAR_FILE_LFS ."
			tar -xvzsf $MYLFS_ROOT/$TAR_FILE_LFS .
		popd
		pushd $LOG_DIR
			echo "tar -xvzf $MYLFS_ROOT/$TAR_FILE_LOG ."
			tar -xvzf $MYLFS_ROOT/$TAR_FILE_LOG .
		popd
	else
		pushd $LFS &> /dev/null
			echo "Restoring LFS"
			#echo "tar -xzsf $MYLFS_ROOT/$TAR_FILE_LFS ."
			tar -xzsf $MYLFS_ROOT/$TAR_FILE_LFS .
		popd &> /dev/null
		pushd $LOG_DIR &> /dev/null
			echo "Restoring Logs"
			#echo "tar -xzf $MYLFS_ROOT/$TAR_FILE_LOG ."
			tar -xzf $MYLFS_ROOT/$TAR_FILE_LOG .
		popd &> /dev/null
	fi
	
	get_LFSPARTUUID $LOOP
	
    # make sure grub.cfg is pointing at the right drive
	# $INSTALL_TGT points to the device which UUID= last partition's UUID
    #local PARTUUID=$(lsblk -o PARTUUID $INSTALL_TGT | tail -1)
	#local PARTUUID=$(lsblk -o PARTUUID $INSTALL_P1 | tail -1)
    sed -Ei "s/root=PARTUUID=[0-9a-z-]+/root=PARTUUID=${LFSPARTUUID}/" $LFS/boot/grub/grub.cfg	
	
	[ $DISK_BOOT != 0 ] && sed -Ei "s/\/boot//" $LFS/boot/grub/grub.cfg	
	[ $DISK_BOOT != 0 ] && sed -Ei "s/search --no-floppy --label DSLsq_ROOT --set=root/search --no-floppy --label $LABEL_BOOT --set=root/" $LFS/boot/grub/grub.cfg	
	
	echo "Files have been restorerd"
	
	#echo "Installing Grub"
	#chroot_do "mountpoint /sys/firmware/efi/efivars ||  mount -t efivarfs efivarfs /sys/firmware/efi/efivars
	#		grub-install --bootloader-id=$OS_ID --recheck"
	
	set -e
	unmount_image
	
	set +x
	
	exit 0
}

# Phased out
function check_dependency {
    local PROG=$1
    local MINVERS=$2
    local MAXVERS=$([ -n "$3" ] && echo $3 || echo "none")

    if ! command -v $PROG &> /dev/null
    then
        echo "ERROR: '$PROG' not found"
        return
    fi

    echo -e "$PROG:\n" \
            "  Minimum: $MINVERS, Maximum: $MAXVERS\n" \
            "  You have: $($PROG --version | head -n 1)"

    return
}

# Required by check_offical_dependency
function ver_check() {
   if ! type -p $2 &>/dev/null
   then 
     echo "ERROR: Cannot find $2 ($1)"; return 1; 
   fi
   v=$($2 --version 2>&1 | grep -E -o '[0-9]+\.[0-9\.]+[a-z]*' | head -n1)
   if printf '%s\n' $3 $v | sort --version-sort --check &>/dev/null
   then 
     printf "OK:    %-9s %-6s >= $3\n" "$1" "$v"; return 0;
   else 
     printf "ERROR: %-9s is TOO OLD ($3 or later required)\n" "$1"; 
     return 1; 
   fi
}

# Required by check_offical_dependency
function ver_kernel() {
   kver=$(uname -r | grep -E -o '^[0-9\.]+')
   if printf '%s\n' $1 $kver | sort --version-sort --check &>/dev/null
   then 
     printf "OK:    Linux Kernel $kver >= $1\n"; return 0;
   else 
     printf "ERROR: Linux Kernel ($kver) is TOO OLD ($1 or later required)\n" "$kver"; 
     return 1; 
   fi
}

function check_offical_dependency {
# A script to list version numbers of critical development tools

# If you have tools installed in other directories, adjust PATH here AND
# in ~lfs/.bashrc (section 4.4) as well.

LC_ALL=C 
PATH=/usr/bin:/bin

bail() { echo "FATAL: $1"; exit 1; }
grep --version > /dev/null 2> /dev/null || bail "grep does not work"
sed '' /dev/null || bail "sed does not work"
sort   /dev/null || bail "sort does not work"

# Coreutils first because --version-sort needs Coreutils >= 7.0
ver_check Coreutils      sort     8.1 || bail "Coreutils too old, stop"
ver_check Bash           bash     3.2
ver_check Binutils       ld       2.13.1
ver_check Bison          bison    2.7
ver_check Diffutils      diff     2.8.1
ver_check Findutils      find     4.2.31
ver_check Gawk           gawk     4.0.1
ver_check GCC            gcc      5.2
ver_check "GCC (C++)"    g++      5.2
ver_check Grep           grep     2.5.1a
ver_check Gzip           gzip     1.3.12
ver_check M4             m4       1.4.10
ver_check Make           make     4.0
ver_check Patch          patch    2.5.4
ver_check Perl           perl     5.8.8
ver_check Python         python3  3.4
ver_check Sed            sed      4.1.5
ver_check Tar            tar      1.22
ver_check Texinfo        texi2any 5.0
ver_check Xz             xz       5.0.0
ver_kernel 5.4 

if mount | grep -q 'devpts on /dev/pts' && [ -e /dev/ptmx ]
then echo "OK:    Linux Kernel supports UNIX 98 PTY";
else echo "ERROR: Linux Kernel does NOT support UNIX 98 PTY"; fi

alias_check() {
   if $1 --version 2>&1 | grep -qi $2
   then printf "OK:    %-4s is $2\n" "$1";
   else printf "ERROR: %-4s is NOT $2\n" "$1"; fi
}
echo "Aliases:"
alias_check awk GNU
alias_check yacc Bison
alias_check sh Bash

echo "Compiler check:"
if printf "int main(){}" | g++ -x c++ -
then echo "OK:    g++ works";
else echo "ERROR: g++ does NOT work"; fi
rm -f a.out

if [ "$(nproc)" = "" ]; then
   echo "ERROR: nproc is not available or it produces empty output"
else
   echo "OK: nproc reports $(nproc) logical cores are available"
fi
    return
}

function is_multilib_compatible(){
	# Return "true" if multilib
	# Return "false" if not enabled

	local FAIL=false
	local TEST="-1"
	echo 'int main(){}' > dummy.c
	gcc -m32 dummy.c
	if [ -f ./a.out ]; then
		TEST=$(readelf -l a.out | grep '/ld-linux')
		rm -f a.out
	else
		FAIL=true
	fi

	if [[ $TEST == "" ]]; then
		FAIL=true
	fi

	gcc -mx32 dummy.c
	if [ -f ./a.out ]; then
		TEST=$(readelf -l a.out | grep '/ld-linux-x32')
		rm -f a.out
	else
		FAIL=true
	fi
	
	if [[ $TEST == "" ]]; then
		FAIL=true
	fi
	
	rm -f dummy.c

	if [[ $FAIL == "true" ]]; then
		echo false
	else
		echo true
	fi
}

function kernel_vers {
    cat /proc/version | head -n1
}

function perl_vers {
    perl -V:version
}

function check_dependencies {
if [[ "$LFS_VERSION" == "11.2" ]]; then
    check_dependency bash        3.2
    check_dependency ld          2.13.1 2.38
    check_dependency bison       2.7
    check_dependency chown       6.9
    check_dependency diff        2.8.1
    check_dependency find        4.2.31
    check_dependency gawk        4.0.1
    check_dependency gcc         4.8 12.2.0
    check_dependency g++         4.8 12.2.0
    check_dependency grep        2.5.1a
    check_dependency gzip        1.3.12
    check_dependency m4          1.4.10
    check_dependency make        4.0
    check_dependency patch       2.5.4
    check_dependency python3     3.4
    check_dependency sed         4.1.5
    check_dependency tar         1.22
    check_dependency makeinfo    4.7
    check_dependency xz          5.0.0
    check_dependency kernel_vers 3.2
    check_dependency perl_vers   5.8.8
fi
if [[ "$LFS_VERSION" == "12.2" ]]; then
    check_dependency bash        3.2
    check_dependency ld          2.13.1 2.38
    check_dependency bison       2.7
    check_dependency chown       6.9
    check_dependency diff        2.8.1
    check_dependency find        4.2.31
    check_dependency gawk        4.0.1
    check_dependency gcc         5.1 12.2.0
    check_dependency g++         5.1 12.2.0
    check_dependency grep        2.5.1a
    check_dependency gzip        1.3.12
    check_dependency m4          1.4.10
    check_dependency make        4.0
    check_dependency patch       2.5.4
    check_dependency python3     3.4
    check_dependency sed         4.1.5
    check_dependency tar         1.22
    check_dependency makeinfo    4.7
    check_dependency xz          5.0.0
    check_dependency kernel_vers 4.14
    check_dependency perl_vers   5.8.8
fi

    # check that yacc is a link to bison
    if [ ! -h /usr/bin/yacc -a "$(readlink -f /usr/bin/yacc)"="/usr/bin/bison.yacc" ]
    then
        echo "WARNING: /usr/bin/yacc should be a link to bison, or a script that executes bison"
    fi

    # check that awk is a link to gawk
    if [ ! -h /usr/bin/awk -a "$(readlink -f /usr/bin/awk)"="/usr/bin/gawk" ]
    then
        echo "WARNING: /usr/bin/awk should be a link to /usr/bin/gawk"
    fi

    # check G++ compilation
    echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
    if [ ! -x dummy ]
    then
        echo "ERROR: g++ compilation failed"
    fi
    rm -f dummy.c dummy
}

function install_static {
    local FILENAME=$1
    local FULLPATH="$LFS/$(basename $FILENAME | sed 's/__/\//g')"
    mkdir -p $(dirname $FULLPATH)
    cp -f $FILENAME $FULLPATH
}

function install_template {
    local FILENAME=$1
    local FULLPATH="$LFS/$(basename $FILENAME | sed 's/__/\//g')"
    mkdir -p $(dirname $FULLPATH)
    cat $FILENAME | envsubst > $FULLPATH
}

function subtract {
	# Simple floating subtract supports only then place and postive result

	A="$1.0"
	B="$2.0"
	A1=$(echo $A | cut -d "." -f 1)
	A2=$(echo $A | cut -d "." -f 2)
	B1=$(echo $B | cut -d "." -f 1)
	B2=$(echo $B | cut -d "." -f 2)

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
	
	RETURN=$A1.$A2
	echo $RETURN
	
}
# subtract 4.1 1.9 && echo $RETURN

function init_image {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

	unmount_image

    if [[ -f $LFS_IMG ]]
    then
        echo "WARNING: $LFS_IMG is present. If you start from the beginning, this file will be deleted."
        [[ $BATCH == "true" ]] && CONFIRM=Y || read -p "Continue? (Y/N): " CONFIRM
        if [[ $CONFIRM == [yY] || $CONFIRM == [yY][eE][sS] ]]
        then
            echo -n "Cleaning... "
            yes | clean_image > /dev/null
            echo "done."
        else
            exit
        fi
	fi
	
	if [ ! -f $LFS_IMG ]
	then
		echo -n "Creating image file... "

		trap "echo 'init failed.' && exit 2" ERR

		$VERBOSE && set -x
		
		set -e

		truncate -s $LFS_IMG_SIZE $LFS_IMG
	fi

echo init_image.LFS_IMG Done

    # attach loop device
    export LOOP=$(losetup -f) # export for grub.sh
	losetup $LOOP $LFS_IMG

echo init_image.attach loop device Done
	
	format_disk $LOOP

    # make sure everything is unmounted first
    unmount_image
	
	common_mount $LOOP

	e2label $LOOP_HOME $LFSROOTLABEL
	if [[ $LOOP_EFI != "" ]]; then fatlabel $LOOP_EFI $LFSEFILABEL; fi
	if [[ $LOOP_BOOT != "" ]]; then e2label $LOOP_BOOT $LFSBOOTLABEL; fi
	udevadm control --reload-rules && udevadm trigger
	
echo init_image.make partition Done

    #echo "done."

    echo -n "Creating basic directory layout... "
	echo ""

echo "     4.2. Creating a Limited Directory Layout in the LFS Filesystem"
    mkdir -p $LFS/{etc,var} 
    mkdir -p $LFS/usr/{bin,lib,sbin}
    for i in bin lib sbin; do
        ln -s usr/$i $LFS/$i
    done
	
    case $(uname -m) in
        x86_64) mkdir -p $LFS/lib64 ;;
    esac

	if [[ "$MULTILIB" == "true" ]]; then
		mkdir -p $LFS/usr/lib{,x}32
		ln -s usr/lib32 $LFS/lib32
		ln -s usr/libx32 $LFS/libx32
	fi
	
    mkdir -p $LFS/tools

echo "     7.3. Preparing Virtual Kernel File Systems"
    mkdir -p $LFS/{dev,proc,sys,run}

echo "     7.5. Creating Directories"
    mkdir -p $LFS/{boot,home,mnt,opt,srv}
    mkdir -p $LFS/etc/{opt,sysconfig}
    mkdir -p $LFS/lib/firmware
    mkdir -p $LFS/media/{floppy,cdrom}
    mkdir -p $LFS/usr/{,local/}{include,src}
	mkdir -p $LFS/usr/lib/locale
    mkdir -p $LFS/usr/local/{bin,lib,sbin}
    mkdir -p $LFS/usr/{,local/}share/{color,dict,doc,info,locale,man}
    mkdir -p $LFS/usr/{,local/}share/{misc,terminfo,zoneinfo}
    mkdir -p $LFS/usr/{,local/}share/man/man{1..8}
    mkdir -p $LFS/var/{cache,local,log,mail,opt,spool}
    mkdir -p $LFS/var/lib/{color,misc,locate}
    
	ln -sf /run $LFS/var/run
    ln -sf /run/lock $LFS/var/lock
    
	install -d -m 0750 $LFS/root
    install -d -m 1777 $LFS/tmp $LFS/var/tmp 

echo "     7.6. Creating Essential Files and Symlinks"
    ln -s /proc/self/mounts $LFS/etc/mtab
    touch $LFS/var/log/{btmp,lastlog,faillog,wtmp}
    chgrp 13 $LFS/var/log/lastlog # 13 == utmp
    chmod 664 $LFS/var/log/lastlog
    chmod 600 $LFS/var/log/btmp

#echo $MAKE_DIR4
    mkdir -p $LFS/boot/grub
    mkdir -p $LFS/etc/{modprobe.d,ld.so.conf.d}

	# [[ $FIRMWARE == "UEFI" ]] && mkdir -p /sys/firmware/efi

# removed at end of build
    mkdir -p $LFS/home/tester &> /dev/null
    chown 101:101 $LFS/home/tester &> /dev/null
    mkdir -p $LFS/sources &> /dev/null
	
echo Copying ./packages-$LFS_VERSION to $LFS/sources
	# In the event of folders and such in the directory, and error is generated.
	# This prevents said error from stopping the program.
	trap - ERR	# reset trap, otherwise last trap is still triggered which has an exit command
	set +e	# to continue even if a command fails
    cp ./packages-$LFS_VERSION/* $LFS/sources
	set -e # to terminate if a command fails

echo install static files
    echo $LFSHOSTNAME > $LFS/etc/hostname
    for f in ./static/*
    do
        install_static $f
    done
    if [ -n "$KERNELCONFIG" ]
    then
        cp $KERNELCONFIG $LFS/boot/config-$KERNELVERS
    fi

echo install templates
    for f in ./templates/*
    do
        install_template $f
    done

echo make special device files
    mknod -m 600 $LFS/dev/console c 5 1
    mknod -m 666 $LFS/dev/null c 1 3

echo mount stuff from the host onto the target disk
    mount --bind /dev $LFS/dev
    mount --bind /dev/pts $LFS/dev/pts
    mount -t proc proc $LFS/proc
    mount -t sysfs sysfs $LFS/sys
    mount -t tmpfs tmpfs $LFS/run

	# [[ $FIRMWARE == "UEFI" ]] && mount -t efivarfs efivarfs $LFS/sys/firmware/efi/efivars

if [[ "$LFS_VERSION" == "11.2" ]];then
    if [ -h $LFS/dev/shm ]; then
      mkdir -p $LFS/$(readlink $LFS/dev/shm)
    fi
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]];then
    if [ -h $LFS/dev/shm ]; then
	  install -v -d -m 1777 $LFS$(realpath /dev/shm)
	else
	  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
    fi
fi

    set +x

    trap - ERR

    echo "done."
}

function reinit_image {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

	[ -f /etc/passwd ] && cp /etc/passwd /etc/passwd.backup
	[ -f /etc/group ] && cp /etc/group /etc/group.backup
	
echo install static files
    echo $LFSHOSTNAME > $LFS/etc/hostname
    for f in ./static/*
    do
        install_static $f
    done
    if [ -n "$KERNELCONFIG" ]
    then
        cp $KERNELCONFIG $LFS/boot/config-$KERNELVERS
    fi

echo install templates
    for f in ./templates/*
    do
        install_template $f
    done

	# Remove tester account
	sed -n '/^.*tester.*$/!p' /etc/passwd > /etc/passwd2
	sed -n '/^.*tester.*$/!p' /etc/group > /etc/group2
	mv -f /etc/passwd2 /etc/passwd
	mv -f /etc/group2 /etc/group
	
    set +x

    trap - ERR

	#echo LFSPARTUUID=$LFSPARTUUID

	[ -f /etc/passwd.backup ] && cp /etc/passwd.backup /etc/passwd
	[ -f /etc/group.backup ] && cp /etc/group.backup /etc/group

    echo "done."
}

function cleanup_cancelled_download {
    local PKG=$PACKAGE_DIR/$(basename $1)
    [ -f $PKG ] && rm -f $PKG
}

function download_packages {
    if [ -n "$1" ]
    then
        # if an extension is being built, it will
        # override the packages and packages-$LFS_VERSION.sh paths
        local PACKAGE_DIR=$1/packages
        local PACKAGE_LIST=$1/packages.sh
    fi

    mkdir -p $PACKAGE_DIR

    [ -f "$PACKAGE_LIST" ] || { echo "ERROR: $PACKAGE_LIST is missing." && exit 1; }

    local PACKAGE_URLS=$(cat $PACKAGE_LIST | grep "^[^#]" | cut -d"=" -f2)
    local ALREADY_DOWNLOADED=$(ls $PACKAGE_DIR)

    { $VERBOSE && echo "Downloading packages... "; } || echo -n "Downloading packages... "

    for url in $PACKAGE_URLS
    do
        trap "cleanup_cancelled_download $url && exit" ERR SIGINT

        $VERBOSE && echo -n "Downloading '$url'... "
        if ! echo $ALREADY_DOWNLOADED | grep $(basename $url) > /dev/null
        then
            if ! curl --location --silent --output $PACKAGE_DIR/$(basename $url) $url
            then
                echo -e "\nERROR: Failed to download URL '$url'"
                exit 1
            fi
            $VERBOSE && echo "done."
        else
            $VERBOSE && echo "already have it - skipping."
        fi

        trap - ERR SIGINT
    done

    echo "done."
}

function mount_image {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

    if [ ! -f $LFS_IMG ]
    then
        echo "ERROR: $LFS_IMG not found - cannot mount."
        exit 1
    fi

	# attach loop device
    export LOOP=$(losetup -f) # export for grub.sh

    # make sure everything is unmounted first
    unmount_image
	
	common_mount $LOOP
	
	$VERBOSE && set -x
	
    # mount stuff from the host onto the target disk
    mkdir -p $LFS/dev && mount --bind /dev $LFS/dev
    mkdir -p $LFS/dev/pts && mount --bind /dev/pts $LFS/dev/pts
    mkdir -p $LFS/proc && mount -t proc proc $LFS/proc
    mkdir -p $LFS/sys && mount -t sysfs sysfs $LFS/sys
    mkdir -p $LFS/run && mount -t tmpfs tmpfs $LFS/run

	#[[ $FIRMWARE == "UEFI" ]] && mount -t efivarfs efivarfs $LFS/sys/firmware/efi/efivars

    set +x
}

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
    local MOUNTED_LOCS=$(mount | grep "$LFS\|$INSTALL_MOUNT")
	# When doing a batch build, I do not want to accidently leave something mounted and 
	# then continue to the next build in the list, corrupting the current build.
    if [ -n "$MOUNTED_LOCS" ] && [[ $BATCH == "true" ]]
    then
		ERROR_NO=-1
		while [[ $ERROR_NO != 0 ]]
		do
			sleep 1
			echo "$MOUNTED_LOCS" | cut -d" " -f3 | tac | xargs umount
			ERROR_NO=$?
			#echo $ERROR_NO
		done
    fi
    if [ -n "$MOUNTED_LOCS" ] && [[ $BATCH != "true" ]]
    then
		echo "$MOUNTED_LOCS" | cut -d" " -f3 | tac | xargs umount
    fi


    # detatch loop device
    local ATTACHED_LOOP=$(losetup | grep $LFS_IMG)
    if [ -n "$ATTACHED_LOOP" ]
    then
		ERROR_NO=-1
		while [[ $ERROR_NO != 0 ]]
		do
			sleep 1
			losetup -d $(echo "$ATTACHED_LOOP" | cut -d" " -f1)
			ERROR_NO=$?
			#echo $ERROR_NO
		done
    fi

    set +x
}

function build_package {
    local NAME=$1
    local NAME_OVERRIDE=$2

    { $VERBOSE && echo "Building $NAME phase $PHASE..."; } || echo -n "Building $NAME phase $PHASE... "
    local PKG_NAME=PKG_$([ -n "$NAME_OVERRIDE" ] && echo $NAME_OVERRIDE || echo $NAME | tr a-z A-Z)

    local LOG_FILE=$([ $PHASE -eq 5 ] && echo "$EXTENSION/logs/${NAME}.log" || echo "$LOG_DIR/${NAME}_phase${PHASE}.log")

	# If calling extentions directly such as via post_run.sh, $EXTENSION is missing the $PWD and tries to place it in $LFS/$EXTENSION/logs/${NAME}.log
	$POST_RUN_LOADED && LOG_FILE=$([ $PHASE -eq 5 ] && echo "$PWD/$EXTENSION/logs/${NAME}.log")

    local SCRIPT_PATH=$([ $PHASE -eq 5 ] && echo $EXTENSION/scripts/${NAME}.sh || echo ./phase${PHASE}/${NAME}.sh)

    if [ "$NAME_OVERRIDE" == "_" ]
    then
        local TARCMD=""
    else
        if [ -z "${!PKG_NAME}" ]
        then
            echo "ERROR: $NAME: package not found"
            return 1
        fi
        local TARCMD="tar -xf $(basename ${!PKG_NAME}) -C $NAME --strip-components=1"
    fi

    local BUILD_INSTR="
        set -ex
        pushd sources > /dev/null
        rm -rf $NAME
        mkdir $NAME
        $TARCMD
        cd $NAME
        $(cat $SCRIPT_PATH)
        popd
        rm -r sources/$NAME
    "
    pushd $LFS > /dev/null

	if $CHROOT
	then
		chroot "$LFS" /usr/bin/env \
						HOME=/root \
						TERM=$TERM \
						PS1='(lfs chroot) \u:\w\$ ' \
						PATH=/usr/bin:/usr/sbin \
						MAKEFLAGS="-j$(nproc)"      \
						TESTSUITEFLAGS="-j$(nproc)" \
						/usr/bin/bash +h -c "$BUILD_INSTR" |& { $VERBOSE && tee $LOG_FILE || cat > $LOG_FILE; }
	else
		eval "$BUILD_INSTR" |& { $VERBOSE && tee $LOG_FILE || cat > $LOG_FILE; }
	fi

    if [ $PIPESTATUS -ne 0 ]
    then
        set +x
        echo -e "\nERROR: $NAME phase $PHASE failed:"
        tail $LOG_FILE
        return 1
    fi

    popd > /dev/null

    if $KEEP_LOGS
    then
        (cd $LOG_DIR && gzip -f $LOG_FILE)
    else
        rm $LOG_FILE
    fi
	
	if [ $PKG_NAME == "complete" ] && [ $PHASE -eq 4 ]
	then
		touch $LOG_DIR/grub_phase4.log
	fi
	
    echo "done."

    return 0
}

function build_phase {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

    PHASE=$1

    if [ -n "$STARTPHASE" ]
    then
        if [ $PHASE -lt $STARTPHASE ] || { $FOUNDSTARTPHASE && $ONEOFF; }
        then
            echo "Skipping phase $PHASE"
            return 0
        else
            FOUNDSTARTPHASE=true
        fi
    fi

    if [ $PHASE -ne 1 -a ! -f $LFS/root/.phase$((PHASE-1)) ]
    then
        echo "ERROR: phases preceeding phase $PHASE have not been built"
        return 1
    fi

    echo -e "# #######\n# Phase $PHASE\n# ~~~~~~~"

    CHROOT=false
    if [ $PHASE -gt 2 ]
    then
        CHROOT=true
    fi

    local PHASE_DIR=./phase$PHASE 

    # Phase 5 == a build extension
    [ $PHASE -eq 5 ] && PHASE_DIR=$EXTENSION

    # make sure ./logs/ dir exists
    mkdir -p $LOG_DIR

	local PKG_LIST=$(grep -Ev '^[#]|^$|^ *$' $PHASE_DIR/build_order.txt)
	
    local PKG_COUNT=$(echo "$PKG_LIST" | wc -l)
    mapfile -t BUILD_ORDER <<< $(echo "$PKG_LIST")

    for ((i=0;i<$PKG_COUNT;i++))
    do
        local pkg="${BUILD_ORDER[$i]}"

        if $FOUNDSTARTPKG && $ONEOFF
        then
            # already found one-off build, just quit
            return 0
        elif [ -n "$STARTPKG" ] && ! $FOUNDSTARTPKG
        then
            # if start package is defined, skip until found
            if [ "$STARTPKG" == "$(echo $pkg | cut -d" " -f1)" ]
            then
                FOUNDSTARTPKG=true
                build_package $pkg || return 1
            else
                continue
            fi
        else
            build_package $pkg || return 1
        fi

    done

    if [ -n "$STARTPKG" -a "$STARTPHASE" == "$PHASE" -a ! $FOUNDSTARTPKG ]
    then
        echo "ERROR: package build '$STARTPKG' not present in phase '$STARTPHASE'"
        return 1
    fi

    touch $LFS/root/.phase$PHASE

    return 0
}

function build_extension {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        return 1
    elif [ ! -d "$EXTENSION" ]
    then
        echo "ERROR: extension '$EXTENSION' is not a directory, or does not exist."
        return 1
    elif [ ! -f "$EXTENSION/packages.sh" ]
    then
        echo "ERROR: extension '$EXTENSION' is missing a 'packages.sh' file."
        return 1
    elif [ ! -f "$EXTENSION/build_order.txt" ]
    then
        echo "ERROR: extension '$EXTENSION' is missing a 'build_order.txt' file."
        return 1
    elif [ ! -d "$EXTENSION/scripts/" ]
    then
        echo "ERROR: extension '$EXTENSION' is missing a 'scripts' directory."
        return 1
    fi

    mkdir -p $EXTENSION/{logs,packages}

    # read in extension config.sh if present
    [ -f "$EXTENSION/config.sh" ] && source "$EXTENSION/config.sh"

    # read packages-$LFS_VERSION.sh (so the extension scripts can see them)
    source "$EXTENSION/packages.sh"

    # download extension packages
    # when download_packages fails, it calls 'exit'.
    # need to make sure image is unmounted if that happens.
    trap 'unmount_image; exit' EXIT
    download_packages $EXTENSION
    trap - EXIT

    $VERBOSE && set -x

    # copy packages onto LFS image
    cp -f $EXTENSION/packages/* $LFS/sources/

    # install static files if present
    if [ -d "$EXTENSION/static" ]
    then
        for f in $EXTENSION/static/*
        do
            install_static $f
        done
    fi

    # install template files if present
    if [ -d "$EXTENSION/templates" ]
    then
        for f in $EXTENSION/templates/*
        do
            install_template $f
        done
    fi

    # build extension
    build_phase 5 || return 1
}

function install_image {
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

    if [ ! -f $LFS_IMG ]
    then
        echo "ERROR: $LFS_IMG does not exist. Be sure to build LFS completely before attempting to install."
        exit 1
    fi

	unmount_image

    local PART_PREFIX=""
    case "$(basename $INSTALL_TGT)" in
      sd[a-z])
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

    read -p "WARNING: This will delete all contents of the device '$INSTALL_TGT'. Continue? (Y/N): " CONFIRM
    if [[ $CONFIRM != [yY] && $CONFIRM != [yY][eE][sS] ]]
    then
        echo "Cancelled."
        exit
    fi

    echo "Installing LFS onto ${INSTALL_TGT}... "

    $VERBOSE && set -x
	
	mkdir -p $LFS $INSTALL_MOUNT
	
	# Format target
	format_disk $INSTALL_TGT
	
	echo "Format of $INSTALL_TGT is done"
	
	common_mount $INSTALL_TGT
	
	echo "Mounting of $INSTALL_TGT is done"
	
    # e2label $INSTALL_HOME $LFSROOTLABEL
	e2label $LOOP_HOME $LFSROOTLABEL
	if [[ $LOOP_EFI != "" ]]; then fatlabel $LOOP_EFI $LFSEFILABEL; fi
	if [[ $LOOP_BOOT != "" ]]; then e2label $LOOP_BOOT $LFSBOOTLABEL; fi
	udevadm control --reload-rules && udevadm trigger
	
	# Mount LFS
	# attach loop device
    export LOOP=$(losetup -f)
	
	common_mount $LOOP	
	
    $VERBOSE && echo "Copying files... " || echo -n "Copying files... "
    cp -r $LFS/* $INSTALL_MOUNT/
    echo "done."

    # make sure grub.cfg is pointing at the right drive
	# $INSTALL_TGT points to the device which UUID= last partition's UUID
	get_LFSPARTUUID $INSTALL_TGT
    sed -Ei "s/root=PARTUUID=[0-9a-z-]+/root=PARTUUID=${LFSPARTUUID}/" $INSTALL_MOUNT/boot/grub/grub.cfg

    mount --bind /dev $INSTALL_MOUNT/dev
    mount --bind /dev/pts $INSTALL_MOUNT/dev/pts
    mount -t sysfs sysfs $INSTALL_MOUNT/sys

    if [[ $FIRMWARE == "BIOS" ]] || [[ $FIRMWARE == "bios" ]]; then
		local GRUB_CMD="grub-install $INSTALL_TGT --target i386-pc"
		$VERBOSE && echo "Installing GRUB. This may take a few minutes... " || echo -n "Installing GRUB. This may take a few minutes... "
		chroot $INSTALL_MOUNT /usr/bin/bash -c "$GRUB_CMD" |& { $VERBOSE && cat || cat > /dev/null; }
	fi
	
    if [[ $FIRMWARE == "UEFI" ]] || [[ $FIRMWARE == "uefi" ]]; then
		local GRUB_CMD="grub-install $GRUB_TARGET --target=x86_64-efi --removable"
		$VERBOSE && echo "Installing GRUB. This may take a few minutes... " || echo -n "Installing GRUB. This may take a few minutes... "
		chroot $INSTALL_MOUNT /usr/bin/bash -c "$GRUB_CMD" |& { $VERBOSE && cat || cat > /dev/null; }
		local GRUB_CMD="grub-install $GRUB_TARGET --bootloader-id=$OS_ID --recheck"
		$VERBOSE && echo "Installing GRUB. This may take a few minutes... " || echo -n "Installing GRUB. This may take a few minutes... "
		chroot $INSTALL_MOUNT /usr/bin/bash -c "$GRUB_CMD" |& { $VERBOSE && cat || cat > /dev/null; }
	fi

    echo "done."

    set +x

    trap - ERR
    unmount_image

    echo "Installed successfully."
}

function clean_image {
	# WARNING: This script is called during the creation of image.
	#			Do not try to clean up files for completion here.
	
    if [ $UID -ne 0 ]
    then
        echo "ERROR: must be run as root."
        exit 1
    fi

    unmount_image

    # delete img
    if [ -f $LFS_IMG ]
    then
        [[ $BATCH == "true" ]] && CONFIRM=Y || read -p "WARNING: This will delete ${LFS_IMG}. Continue? (Y/N): " CONFIRM
        if [[ $CONFIRM == [yY] || $CONFIRM == [yY][eE][sS] ]]
        then
            echo "Deleting ${LFS_IMG}..."
            rm $LFS_IMG
        fi
    fi

    # delete logs
    if [ -d $LOG_DIR ] && [ -n "$(ls $LOG_DIR)" ]
    then
        rm $LOG_DIR/*
    fi
}

function convert_img_vdi {
	#ToDo add check for VirtualBox is installed
	local skip=false

	if [ -f $LFS_VDI ]; then
		rm -f $LFS_VDI
	fi
	
	if [ ! -f $LFS_IMG ]; then
		echo "Error: $LFS_IMG not found"
		skip=true
	fi	

	if [[ $CUSTOM_VDI_UUID != "true" ]] && [ $skip == "false" ]; then
		$(VBoxManage convertfromraw $LFS_IMG $(basename $LFS_IMG .img).vdi --format VDI --variant Standard)
	fi
	
	if [[ $CUSTOM_VDI_UUID == "true" ]] && [ $skip == "false" ]; then
		$(VBoxManage convertfromraw $LFS_IMG $(basename $LFS_IMG .img).vdi --format VDI --variant Standard --uuid $VDI_UUID)
	fi
	#" Fix for a complaint looking for a missing quote
}

function is_multilib_compatible_test {
	if [[ $(is_multilib_compatible) == "false" ]]; then
		echo "Error: your system is not multilib enabled."
		echo "Tested with Debian Bookworm with:"
		echo "apt install -y g++-multilib binutils-multiarch gcc-multilib"
		echo "sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="syscall.x32=y quiet"/g' /etc/default/grub"
		echo "sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="syscall.x32=y"/g' /etc/default/grub"
		echo "update-grub2 && reboot"
	else
		echo "Pass: your system is multilib enabled."
	fi
}

function main {
    # Perform single operations
    #$CHECKDEPS && check_dependencies && exit
	$CHECKDEPS && check_offical_dependency && exit
	$CHECKMULTI && is_multilib_compatible_test && exit
    $DOWNLOAD && download_packages && exit
    $INIT && download_packages && init_image && unmount_image && exit
	$REINIT && mount_image && reinit_image && unmount_image && exit
    $MOUNT && mount_image && exit
	if $DO_CHROOT
	then
		mount_image
		chroot "$LFS" /usr/bin/env \
						HOME=/root \
						TERM=$TERM \
						PS1='(lfs chroot) \u:\w\$ ' \
						PATH=/usr/bin:/usr/sbin \
						MAKEFLAGS="-j$(nproc)"      \
						TESTSUITEFLAGS="-j$(nproc)" \
						/usr/bin/bash --login +h
		unmount_image				
		exit
	fi
	$UNMOUNT && unmount_image && exit
    $CLEAN && clean_image && exit
	$BACKUP && make_backup && exit
	$RESTORE && do_restore && exit
	
    [ -n "$INSTALL_TGT" ] && install_image && exit

    if [ -n "$STARTPHASE" ]
    then
        download_packages
        mount_image
    elif $BUILDALL
    then
        download_packages
        init_image
    else
        usage
        exit
    fi

    PATH=$LFS/tools/bin:$PATH
    CONFIG_SITE=$LFS/usr/share/config.site
    LC_ALL=POSIX
    export LC_ALL PATH CONFIG_SITE

    trap "echo 'build cancelled.' && cd $FULLPATH && unmount_image && exit -1" SIGINT
    trap "echo 'build failed.' && cd $FULLPATH && unmount_image && exit 1" ERR

    build_phase 1 || { unmount_image && exit; }

    $ONEOFF && $FOUNDSTARTPHASE && unmount_image && exit

    build_phase 2 || { unmount_image && exit; }

    $ONEOFF && $FOUNDSTARTPHASE && unmount_image && exit

    build_phase 3 || { unmount_image && exit; }

    # phase 3 cleanup
    if $BUILDALL || [ "$STARTPHASE" -le "3" ]
    then
        rm -rf $LFS/usr/share/{info,man,doc}/*
        find $LFS/usr/{lib,libexec} -name \*.la -delete
		
		if [[ "$MULTILIB" == "true" ]]; then
			find $LFS/usr/lib{,x}32 -name \*.la -delete
        fi
		
		rm -rf $LFS/tools
    fi

    $ONEOFF && $FOUNDSTARTPHASE && unmount_image && exit

    build_phase 4 || { unmount_image && exit; }

    $ONEOFF && $FOUNDSTARTPHASE && unmount_image && exit

    [ -n "$EXTENSION" ] && { build_extension || { unmount_image && exit; }; }

    rm -rf $LFS/tmp/*
    find $LFS/usr/lib $LFS/usr/libexec -name \*.la -delete
    find $LFS/usr -depth -name $LFS_TGT\* | xargs rm -rf
    rm -rf $LFS/home/tester
    sed -i 's/^.*tester.*$//' $LFS/etc/{passwd,group}

	# Install extra extentions such as curl and openssh
	# 
	[ -f post_run.sh ] && POST_RUN_LOADED=true && source ./post_run.sh

    # unmount and detatch image
    unmount_image

    echo "build successful."
	
	if [[ $MAKEVDI == "true" ]]; then
		convert_img_vdi
		echo "VDI build finished."
	fi
	
	exit 0
}

function check_required_tools {
	if [[ $FIRMWARE == "UEFI" ]] && [[ ! $(command -v mkfs.vfat) ]]; then echo "dosfstools is required for UEFI support"; exit -1; fi
}

# ###############
# Parse arguments
# ~~~~~~~~~~~~~~~

welcome

cd $(dirname $0)

echo "Loading Configs"
# import config vars
source ./config.sh
	
if [[ $ALWAYS_REBUILD -ne "true" ]] || [ ! -f ./packages-$LFS_VERSION.sh ]; then
	echo "./packages-$LFS_VERSION.sh not found, Making & Reloading Configs"
	# Always run to verify configh.sh changes take effect without having to run clean
	./make_version.sh
	# Reload config.sh due to a circular reference
	source ./config.sh
fi

if [[ $ALWAYS_REBUILD == "true" ]]; then
	echo "ReMaking & Loading Configs"
	# Always run to verify configh.sh changes take effect without having to run clean
	./make_version.sh
	# Reload config.sh due to a circular reference
	source ./config.sh
fi

check_required_tools

if [[ $MULTILIB == "true" ]] && [[ $(is_multilib_compatible) == "false" ]]; then
	echo "Error: your system is not multilib enabled."
	echo "Tested with Debian Bookworm with:"
	echo "sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="syscall.x32=y quiet"/g' /etc/default/grub"
	echo "sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="syscall.x32=y"/g' /etc/default/grub"
	echo "update-grub2 && reboot"
	
	exit 1
fi

VERBOSE=false
CHECKDEPS=false
CHECKMULTI=false
BUILDALL=false
DOWNLOAD=false
INIT=false
REINIT=false
ONEOFF=false
FOUNDSTARTPKG=false
FOUNDSTARTPHASE=false
MOUNT=false
UNMOUNT=false
CLEAN=false
BACKUP=false
RESTORE=false
DO_CHROOT=false
POST_RUN_LOADED=false

while [ $# -gt 0 ]; do
  case $1 in
    --vdi)
      convert_img_vdi
	  exit
      ;;
    -v|--version)
      echo $LFS_VERSION
      exit
      ;;
    -V|--verbose)
      VERBOSE=true
      shift
      ;;
    -e|--check)
      CHECKDEPS=true
      shift
      ;;
    --multilib)
      CHECKMULTI=true
      shift
      ;;
    -b|--build-all)
      BUILDALL=true
      shift
      ;;
    -x|--extend)
      EXTENSION="$2"
      shift
      shift
      ;;
    -d|--download-packages)
      DOWNLOAD=true
      shift
      ;;
    -i|--init)
      INIT=true
      shift
      ;;
    -p|--start-phase)
      STARTPHASE="$2"
      [ -z "$STARTPHASE" ] && echo "ERROR: $1 missing argument." && exit 1
      shift
      shift
      ;;
    -a|--start-package)
      STARTPKG="$2"
      [ -z "$STARTPKG" ] && echo "ERROR: $1 missing argument." && exit 1
      shift
      shift
      ;;
    -o|--one-off)
      ONEOFF=true
      shift
      ;;
    -k|--kernel-config)
      KERNELCONFIG="$2"
      [ -z "$KERNELCONFIG" ] && echo "ERROR: $1 missing argument." && exit 1
      shift
      shift
      ;;
    -m|--mount)
      MOUNT=true
      shift
      ;;
    -u|--umount)
      UNMOUNT=true
      shift
      ;;
    -n|--install)
      INSTALL_TGT="$2"
      [ -z "$INSTALL_TGT" ] && echo "ERROR: $1 missing argument." && exit 1
      shift
      shift
      ;;
    -c|--clean)
      CLEAN=true
      shift
      ;;
    -h|--help)
      usage
      exit
      ;;
    --env)
	  MOUNT=true
      shift
      env
      shift
	  ;;
    -r|--resume)
      fPHASE
	  fSCRIPT
	  #echo $STARTPHASE
	  #echo $STARTPKG
	  shift
      ;;	  
    --backup)
      BACKUP=true
	  shift
      ;;		  
    --restore)
      RESTORE=true
	  shift
      ;;
    --reinit)
      REINIT=true
      shift
	  ;;
	--make_clean)
	  make_clean
	  shift
	  exit
	  ;;
    --chroot)
      DO_CHROOT=true
	  shift
      ;;	 
    *)
      echo "Unknown option $1"
      usage
      exit 1
      ;;
  esac
done

OPCOUNT=0
for OP in BUILDALL CHECKDEPS DOWNLOAD INIT REINIT STARTPHASE MOUNT UNMOUNT INSTALL_TGT CLEAN
do
    OP="${!OP}"
    if [ -n "$OP" -a "$OP" != "false" ]
    then
        OPCOUNT=$((OPCOUNT+1))
    fi

    if [ $OPCOUNT -gt 1 ]
    then
        echo "ERROR: too many options."
        exit 1
    fi
done

if [ -n "$STARTPHASE" ]
then
    if ! [[ "$STARTPHASE" =~ ^[1-5]$ ]]
    then
        echo "ERROR: -p|--start-phase must specify a number between 1 and 5. $STARTPHASE"
        exit 1
    elif [ "$STARTPHASE" -eq 5 ] && [ -z "$EXTENSION" ]
    then
        echo "ERROR: phase 5 only exists if an -x|--extend has been specified."
        exit 1
    elif [ ! -f $LFS_IMG ]
    then
        echo "ERROR: $LFS_IMG not found - cannot start from phase $STARTPHASE."
        exit 1
    fi
fi

if [ -n "$STARTPKG" -a -z "$STARTPHASE" ]
then
    echo "ERROR: -p|--start-phase must be defined if -a|--start-package is defined."
    exit 1
elif $ONEOFF && [ -z "$STARTPHASE" ]
then
    echo "ERROR: -o|--one-off has no effect without a starting phase selected."
    exit 1
fi

if [ -n "$EXTENSION" ]
then
    if ! $BUILDALL && [ -z "$STARTPHASE" ]
    then
        echo "ERROR: -x|--extend has no effect without either -b|--build-all or -p|--start-phase set."
        exit 1
    elif $ONEOFF && [ "$STARTPHASE" -ne 5 ]
    then
        echo "ERROR: -x|--extend has no effect if -o|--one-off is set and -p|--start-phase != 5."
        exit 1
    elif [ ! -d "$EXTENSION" ]
    then
        echo "ERROR: '$EXTENSION' is not a directory or does not exist."
    fi

    # get full path to extension
    EXTENSION="$(cd $(dirname $EXTENSION) && pwd)/$(basename $EXTENSION)"
fi

# ###########
# Start build
# ~~~~~~~~~~~

main
