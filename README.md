# MyLFS
	It's a giant bash script that builds Linux From Scratch.

	Pronounce it in whatever way seems best to you.

	If you don't know what this is, or haven't built Linux From Scratch on your own before, you should go through the LFS [book](https://linuxfromscratch.org) before using this script.
	
	This does add some options over the original MyLFS by Kyle Glaws, in this version:
		SystemD is supported.
		Multiarch is supported.
		Boot Partition is supported (requireds initramfs which is not in the standard LFS)
		Swap Partition is supported
		UEFI (non secure boot) is supported (requireds tools which is not in the standard LFS)
		LFS 12.2 is supported
		Some automation tools are added
		VirtualBox export is supported
		Backup and restore is supported

## Tools
	batch_build.sh is for testing the status of the script with all targets. (init-V and SystemD with thier multilib variants)
	make_version.sh is a helper file for ./mylfs.  It is not meant to be ran by the user.
	runqemu.sh is the orginal projects method for running the image.

## How To Use
	Start with a system check `sudo ./mylfs.sh --check` and verify your build enviroment is set up correctly
	
	If you want to do MLFS, do a system check by `sudo ./mylfs.sh --multi` and verify your build enviroment is set up correctly

	Basically, just run `sudo ./mylfs.sh --build-all` and then stare at your terminal for several hours. Maybe meditate on life or something while you wait. Or maybe clean your room or do your dishes finally. I don't know. Do whatever you want. Maybe by the end of the script, you'll realize why you love linux so much: you love it because it is *hard*. Just like going to the moon, god dammit.

	```
	$ sudo ./mylfs.sh --help

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

		-r|--resume				Continue where process was interupted.
		
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

        --vdi              		This make a VirtualBox VDI file from the $LFS_IMG.

        --backup              	This make a $LFS_IMG.tar.gz of the location $LFS + $LOG_DIR.

        --restore              	This restores a $LFS + $LOG_DIR from a $LFS_IMG.tar.gz.
		
        --reinit              	This reruns the copy static and template files.
		
		--make_clean			Cleans the MyLFS project

        -h|--help               Show this message.
	```

## How It Works

	The script builds LFS by completing the following steps:


	1. config.sh's $LFS_VERSION will select the version you want to build.  (Default is latest verified working)


	2. The tool ./make_version.sh will pull ./wget-lists/wget-list-$LFS_VERSION and make the needed additional configuration files.


	3. Download package source code and save to the `./packages/` directory.


	4. Create a 10 gigabyte IMG file called `lfs-$LFSINIT-$LFS_VERSION(-multilib).img`. This will serve as a virtual hard drive on which to build LFS.


	5. "Attach" the IMG file as a loop device using `losetup`. This way, the host machine can operate on the IMG file as if it were a physical storage device.


	6. Partition the IMG file via the loop device we've created, put an ext4 filesystem on it, then add a basic directory structure and some config files (such as /boot/grub/grub.cfg etc).


	7. Build initial cross compilation tools. This corresponds to chapter 5 in the LFS book.


	8. Begin to build tools required for minimal chroot environment. (chapter 6)


	9. Enter chroot environment, and build remaing tools needed to build the entire LFS system. (chapter 7)


	10. Build the entire LFS system from within chroot envirnment, including the kernel, GRUB, and others. (chapter 8)


	That's it.


## Examples
	If something breaks over the course of the build, you can examine the build logs in the aptly named `logs` directory. If you discover the source of the breakage and manage to fix it, you can start the script up again from where you left off using the `--start-phase <phase-number>` and `--start-package <package-name>` commands.


	For example, say the GRUB build in phase 4 broke:
	```sh
	sudo ./mylfs.sh --start-phase 4 --start-package grub
	```
	This will start the script up again at the phase 4 GRUB build, and continue on to the remaining packages.


	Another example. Say you just changed your kernel config file a bit and need to recompile:
	```sh
	sudo ./mylfs.sh --start-phase 4 --start-package linux --one-off
	```
	The `--one-off` flag tells the script to exit once the starting package has been completed.


	The real magic of MyLFS is that you can apply "extensions" to the script in order to automatically customize your LFS system.
	```sh
	sudo ./mylfs.sh --build-all --extend ./example_extension
	```
	Details on how extensions work can be found in `example_extension/README`.


	If you want to poke around inside the image file without booting into it, you can simply use the `--mount` command like so:
	```sh
	sudo ./mylfs.sh --mount
	```
	This will mount the root partition of the IMG file under `./mnt/lfs` (i.e. not `/mnt` under the root directory). When you're done, you can unmount with the following:
	```sh
	sudo ./mylfs.sh --umount
	```  

	If you want to install the LFS IMG file onto a drive of some kind, use:
	```sh
	sudo ./mylfs.sh --install /dev/<devname>
	```


	Finally, to clean your workspace:
	```sh
	sudo ./mylfs.sh --clean
	```
	This will unmount the IMG file (if it is mounted), delete it, and delete the logs under `./logs/`. It will not delete the cached package archives under `./packages/`, but if you really want to do that you can easily `rm -f ./packages/*`.  

## Adding a new LFS Version
	Copy the wget-list to ./wget-lists/wget-list-xx.y
		uefi needs the following added:
			cpio
			isl
			efivar
			efibootmgr
			unifont
			dosfstools
			popt
			freetype
			freetype-doc
		and save the list as ./wget-lists/wget-list-xx.y-uefi
	Update make_version.sh to add function build_order_initv_xx.y and function build_order_systemd_xx.y
	
## Booting
	So far, I have managed to boot the IMG file using QEMU (see the [runqemu.sh](runqemu.sh) script) and on bare metal using a flash drive. I have not been able to boot it up on a VM yet.

## Virtual Box VDI
	In Windows you can convert the IMG file to VDI using the command "&'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' convertfromraw lfs-systemd-12.2.img lfs-systemd-12.2.vdi --format VDI --variant Standard"
	In Linux you can convert the IMG file to VDI using ./mylfs --vdi or setting "makevdi=true" in the configh.sh or even better, customization.sh

## Debain Bookworm Host

	# Current VirtualBox Method:
		wget -O- -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | tee /etc/apt/sources.list.d/virtualbox.list
		apt update
		apt install virtualbox-7.1

	# Old VirtualBox Method:
		echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-fasttrack main contrib" >> /etc/apt/sources.list
		echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-backports-staging main contrib" >> /etc/apt/sources.list
		apt update
		apt install virtualbox

	# Preserve bash settings for root
		cp /etc/bash.bashrc /root/.bashrc

	# 4.4. Setting Up the Environment
		[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

	# Enable Multilib support on Debian
		sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="syscall.x32=y quiet"/g' /etc/default/grub
		sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="syscall.x32=y"/g' /etc/default/grub
		update-grub2

## Error Codes
	255 means a build process failed
	254 means a missing / undefined but required variable