#!/bin/bash

clear

# Configuration Options
	export CONFIG_OVERRIDE=true 	# Used in config.sh
	export BATCH=true				# Used in mylfs.sh
	export BRIDGEADAPTER1="enp0s3"	# VBoxManage list bridgedifs
	#export MAKE_VB_VM=true
	#export RETRY_BUILD=0
	MULTILIB_ALWAYS=true
	#DEBUG_BATCH_BUILD=true
	#SKIP_MAKE_VDI=true

function build_lfs {
	echo "Running ./mylfs.sh"
	local TEST=0
	local BUILD_TRIES=0
	local VDI_MADE=false
	
	./mylfs.sh -b
	local TEST=$?
	# echo "TEST=$TEST"
	if [[ $TEST == 0 ]]; then
		./mylfs.sh -x extension_curl -p 5
		./mylfs.sh -x extension_openssh -p 5
		#echo "Exit Code=$?"
	else
		echo "Skipping extentions due to local var TEST=$TEST"
	fi
	if [[ $SKIP_MAKE_VDI == "true" ]]; then
		echo "Skipping VDI due to SKIP_MAKE_VDI is selected"
	fi
	if [[ $SKIP_MAKE_VDI != "true" ]] && [[ $TEST == 0 ]]; then
		./mylfs.sh --vdi
		TEST=$?
		#echo "Exit Code=$?"
		if [[ $TEST == 0 ]]; then
			VDI_MADE=true
		fi
	fi
	if [[ $VDI_MADE == "true" ]] && [[ $MAKE_VB_VM == "true" ]]; then
		build_virtualbox_vm
	fi
}

#LFS_IMG=lfs-initv-12.2.img
#LFS_VDI=lfs-initv-12.2.vdi

function build_virtualbox_vm {
	MACHINENAME=$(basename $LFS_IMG .img)
	
	# General
	# Basic
	
	VBoxManage createvm --name $MACHINENAME --ostype "Debian12_64" --register --basefolder "$PWD/VirtualBox VMs/"
	# VBoxManage unregistervm $MACHINENAME --delete

	# Advanced
	# VBoxManage createvm --name $MACHINENAME --snapshotfolder default
	# VBoxManage createvm --name $MACHINENAME --clipboard-mode disabled
	# VBoxManage createvm --name $MACHINENAME --draganddrop disabled

	# Encryption
	# Enable Disk ENc

	# System
	# Motherboard
	VBoxManage modifyvm $MACHINENAME --memory 8192
	VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
	VBoxManage modifyvm $MACHINENAME --chipset ich9
	VBoxManage modifyvm $MACHINENAME --mouse usbtablet
	VBoxManage modifyvm $MACHINENAME --ioapic on
	VBoxManage modifyvm $MACHINENAME --firmware bios # bios | efi | efi32 | efi64
	VBoxManage modifyvm $MACHINENAME --rtcuseutc on
	VBoxManage modifyvm $MACHINENAME --tpm-type=none # none | 1.2 | 2.0 | host | swtpm
	#VBoxManage modifyvm $MACHINENAME --tpm-location= location

	#VBoxManage modifynvram $MACHINENAME inituefivarstore
	#vboxmanage modifynvram $MACHINENAME enrollmssignatures
	#vboxmanage modifynvram $MACHINENAME enrollorclpk

	# Processor
	VBoxManage modifyvm $MACHINENAME --cpus 2
	#VBoxManage modifyvm $MACHINENAME --nested-hw-virt on
	#VBoxManage modifyvm $MACHINENAME --iommu=automatic

	# Acceleration
	VBoxManage modifyvm $MACHINENAME --nestedpaging on

	# Display
	# Screen
	VBoxManage modifyvm $MACHINENAME --vram 128
	VBoxManage modifyvm $MACHINENAME --monitorcount 1
	VBoxManage modifyvm $MACHINENAME --graphicscontroller vmsvga
	VBoxManage modifyvm $MACHINENAME --accelerate3d on

	# #ote Display
	VBoxManage modifyvm $MACHINENAME --vrde off
	VBoxManage modifyvm $MACHINENAME --vrdemulticon on --vrdeport 10001

	# Recording
	VBoxManage modifyvm $MACHINENAME --recording off

	# Storage
	# Create Disk
	#VBoxManage createmedium disk --filename "%USERPROFILE%/VirtualBox VMs/$MACHINENAME/$MACHINENAME_DISK.vdi" --size 256000 --format VDI
	#VBoxManage createmedium disk --filename "%USERPROFILE%/VirtualBox VMs/$MACHINENAME/$MACHINENAME_SATA1.vdi" --size 32000 --format VDI

	# Connect Disk
	VBoxManage storagectl $MACHINENAME --name "SATA" --add sata --controller IntelAhci
	VBoxManage storageattach $MACHINENAME --storagectl "SATA" --port 1 --device 0 --type hdd --hotpluggable on --medium  $PWD/$LFS_VDI
	VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
	#VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium C:/proxmox-ve_7.3-1.iso

	# Audio

	# Network
	VBoxManage modifyvm $MACHINENAME --nic1 bridged
	VBoxManage modifyvm $MACHINENAME --bridgeadapter1=$BRIDGEADAPTER1
	#VBoxManage modifyvm $MACHINENAME --intnet1=intnet1
	VBoxManage modifyvm $MACHINENAME --nictype1 virtio 
	VBoxManage modifyvm $MACHINENAME --nicpromisc1 allow-all
	VBoxManage modifyvm $MACHINENAME --cableconnected1 on

	#VBoxManage modifyvm $MACHINENAME --nic2 intnet 
	#VBoxManage modifyvm $MACHINENAME --intnet2=intnet2
	#VBoxManage modifyvm $MACHINENAME --nictype2 virtio 
	#VBoxManage modifyvm $MACHINENAME --nicpromisc2 deny
	#VBoxManage modifyvm $MACHINENAME --cableconnected2 on


	# Serial Ports

	# USB
	VBoxManage modifyvm $MACHINENAME --usbxhci on

	# Shared Folders
	# --draganddrop disabled|hosttoguest|guesttohost|bidirectional
	# --clipboard-mode disabled|hosttoguest|guesttohost|bidirectional

	# User Interface

	# Unattended
	#  VBoxManage unattended install $MACHINENAME --iso=%USERPROFILE%/Downloads/proxmox-ve_7.2-1.iso --user=login --full-user-name=name --password password --install-additions --time-zone=CET

	# Start the VM
	# VBoxHeadless --startvm $MACHINENAME
	# vboxmanage startvm $MACHINENAME


	# vboxmanage controlvm $MACHINENAME poweroff
}

function make_test {
touch WARNING_TEST_BUILD
mv ./phase1/build_order.txt ./phase1/build_order.txt.backup
mv ./phase2/build_order.txt ./phase2/build_order.txt.backup

cat << EOF > ./phase1/build_order.txt
#binutils
#gcc
linux_headers LINUX
#glibc
#libstdcpp GCC

EOF

cat << EOF > ./phase2/build_order.txt
m4
#ncurses
#bash
#coreutils
#diffutils
#file
#findutils
#gawk
#grep
#gzip
#make
#patch
#sed
#tar
#xz
#binutils
#gcc

EOF
}

function undo_make_test {
	if [ -f ./phase1/build_order.txt.backup ]; then
		mv -f ./phase1/build_order.txt.backup ./phase1/build_order.txt
	fi
	if [ -f ./phase2/build_order.txt.backup ]; then
		mv -f ./phase2/build_order.txt.backup ./phase2/build_order.txt
	fi
	if [ -f ./WARNING_TEST_BUILD ]; then
		rm -f WARNING_TEST_BUILD
	fi
}

function make_configurations {
# Generate Batch Config
	./mylfs.sh --make_clean
	if [ -f ./WARNING_TEST_BUILD ]; then
		undo_make_test
	fi

	if [ -f ./customization_override.sh ]; then
		rm -f customization_override.sh
	fi

echo "Loading config.sh"
	if [[ $MULTILIB_ALWAYS != "true" ]]; then
		source ./config.sh
		export MULTILIB2=$MULTILIB
	fi

	if [ -f ./customization.sh ]; then
		cp ./customization.sh ./customization_override.sh
	else
		echo export LFS_VERSION= > ./customization_override.sh
		echo export LFSINIT= > ./customization_override.sh
		echo export MULTILIB= >> ./customization_override.sh
		echo export MAKEVDI= >> ./customization_override.sh
		echo export ALWAYS_REBUILD= >> ./customization_override.sh
	fi
	
	# Ensure all variables are present in customization_override.sh
	
	if [[ ! $(cat customization_override.sh | grep LFS_VERSION) ]]; then  echo export LFS_VERSION= >> ./customization_override.sh; fi
	if [[ ! $(cat customization_override.sh | grep LFSINIT) ]]; then  echo export LFSINIT= >> ./customization_override.sh; fi
	if [[ ! $(cat customization_override.sh | grep MULTILIB) ]]; then echo export  MULTILIB= >> ./customization_override.sh; fi
	if [[ ! $(cat customization_override.sh | grep MAKEVDI)t ]]; then echo export MAKEVDI= >> ./customization_override.sh; fi
	if [[ ! $(cat customization_override.sh | grep ALWAYS_REBUILD) ]]; then  echo export ALWAYS_REBUILD= >> ./customization_override.sh; fi
}

function run_build_11.2_initv {
	# Start Build Commands
	echo ""
	echo "##################"
	echo "11.2 Init-V Single"
	echo "##################"
	echo ""
		
	sed -i "s/.*export LFS_VERSION=.*/export LFS_VERSION=11.2/" ./customization_override.sh
	sed -i "s/.*export LFSINIT=.*/export LFSINIT=initv/" ./customization_override.sh
	sed -i "s/.*export MULTILIB=.*/export MULTILIB=false/" ./customization_override.sh
	sed -i "s/.*export MAKEVDI=.*/export MAKEVDI=false/" ./customization_override.sh
	sed -i "s/.*export ALWAYS_REBUILD=.*/export ALWAYS_REBUILD=true/" ./customization_override.sh
	
	build_lfs
}

function run_build_11.2_systemd {
	# Start Build Commands
	echo ""
	echo "###################"
	echo "11.2 SystemD Single"
	echo "###################"
	echo ""

	sed -i "s/.*export LFS_VERSION=.*/export LFS_VERSION=11.2/" ./customization_override.sh
	sed -i "s/.*export LFSINIT=.*/export LFSINIT=systemd/" ./customization_override.sh
	sed -i "s/.*export MULTILIB=.*/export MULTILIB=false/" ./customization_override.sh
	sed -i "s/.*export MAKEVDI=.*/export MAKEVDI=false/" ./customization_override.sh
	sed -i "s/.*export ALWAYS_REBUILD=.*/export ALWAYS_REBUILD=true/" ./customization_override.sh

	build_lfs
}

function run_build_12.2_initv {
	# Start Build Commands
	echo ""
	echo "##################"
	echo "12.2 Init-V Single"
	echo "##################"
	echo ""
		
	sed -i "s/.*export LFS_VERSION=.*/export LFS_VERSION=12.2/" ./customization_override.sh
	sed -i "s/.*export LFSINIT=.*/export LFSINIT=initv/" ./customization_override.sh
	sed -i "s/.*export MULTILIB=.*/export MULTILIB=false/" ./customization_override.sh
	sed -i "s/.*export MAKEVDI=.*/export MAKEVDI=false/" ./customization_override.sh
	sed -i "s/.*export ALWAYS_REBUILD=.*/export ALWAYS_REBUILD=true/" ./customization_override.sh
	
	build_lfs
}

function run_build_12.2_systemd {
	# Start Build Commands
	echo ""
	echo "###################"
	echo "12.2 SystemD Single"
	echo "###################"
	echo ""

	sed -i "s/.*export LFS_VERSION=.*/export LFS_VERSION=12.2/" ./customization_override.sh
	sed -i "s/.*export LFSINIT=.*/export LFSINIT=systemd/" ./customization_override.sh
	sed -i "s/.*export MULTILIB=.*/export MULTILIB=false/" ./customization_override.sh
	sed -i "s/.*export MAKEVDI=.*/export MAKEVDI=false/" ./customization_override.sh
	sed -i "s/.*export ALWAYS_REBUILD=.*/export ALWAYS_REBUILD=true/" ./customization_override.sh

	build_lfs
}

function run_build_12.2_initv_multilib {
	# Start Build Commands
	echo ""
	echo "#################"
	echo "12.2 Init-V Multi"
	echo "#################"
	echo ""

	sed -i "s/.*export LFS_VERSION=.*/export LFS_VERSION=12.2/" ./customization_override.sh
	sed -i "s/.*export LFSINIT=.*/export LFSINIT=initv/" ./customization_override.sh
	sed -i "s/.*export MULTILIB=.*/export MULTILIB=true/" ./customization_override.sh
	sed -i "s/.*export MAKEVDI=.*/export MAKEVDI=false/" ./customization_override.sh
	sed -i "s/.*export ALWAYS_REBUILD=.*/export ALWAYS_REBUILD=true/" ./customization_override.sh

	build_lfs
}

function run_build_12.2_systemd_multilib {
	# Start Build Commands
	echo ""
	echo "##################"	
	echo "12.2 SystemD Multi"
	echo "##################"
	echo ""

	sed -i "s/.*export LFS_VERSION=.*/export LFS_VERSION=12.2/" ./customization_override.sh
	sed -i "s/.*export LFSINIT=.*/export LFSINIT=systemd/" ./customization_override.sh
	sed -i "s/.*export MULTILIB=.*/export MULTILIB=true/" ./customization_override.sh
	sed -i "s/.*export MAKEVDI=.*/export MAKEVDI=false/" ./customization_override.sh
	sed -i "s/.*export ALWAYS_REBUILD=.*/export ALWAYS_REBUILD=true/" ./customization_override.sh

	build_lfs
}

function batch_build_main {
	if [[ $DEBUG_BATCH_BUILD == "true" ]]; then
		make_test
	fi

	run_build_11.2_initv
	run_build_11.2_systemd
	
	run_build_12.2_initv
	run_build_12.2_systemd
	if [[ $MULTILIB2 == "true" ]] || [[ $MULTILIB_ALWAYS == "true" ]]; then
		run_build_12.2_initv_multilib
		run_build_12.2_systemd_multilib
	fi

	if [ -f ./customization_override.sh ]; then
		echo "Removing customization_override.sh"
		rm -f ./customization_override.sh
	fi
	
	# Created by build.sh
	if [ -f ./current_build.sh ]; then
		echo "Removing current_build.sh"
		rm -f ./current_build.sh
	fi
	
	undo_make_test
		
}

make_configurations
batch_build_main #

echo "Done" 
	