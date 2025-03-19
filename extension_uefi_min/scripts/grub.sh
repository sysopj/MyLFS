# Grub Phase 4

if [[ $FIRMWARE == "UEFI" ]]; then
	KERNELVAR=$((basename $PKG_LINUX .tar.xz) | cut -d "-" -f 2)

	# Requirement Checks
	CONFIG_EFI=false
	CONFIG_EFI_STUB=false
	CONFIG_BLOCK=false
	CONFIG_PARTITION_ADVANCED=false
	CONFIG_EFI_PARTITION=false
	CONFIG_SYSFB_SIMPLEFB=false
	CONFIG_DRM=false
	CONFIG_DRM_FBDEV_EMULATION=false
	CONFIG_DRM_SIMPLEDRM=false
	CONFIG_FRAMEBUFFER_CONSOLE=false
	CONFIG_VFAT_FS=false
	CONFIG_EFIVAR_FS=false
	CONFIG_NLS=false
	CONFIG_NLS_CODEPAGE_437=false
	CONFIG_NLS_ISO8859_1=false

	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_EFI=y) ] && CONFIG_EFI=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_EFI_STUB=y) ] && CONFIG_EFI_STUB=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_BLOCK=y) ] && CONFIG_BLOCK=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_PARTITION_ADVANCED=y) ] && CONFIG_PARTITION_ADVANCED=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_EFI_PARTITION=y) ] && CONFIG_EFI_PARTITION=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_SYSFB_SIMPLEFB=y) ] && CONFIG_SYSFB_SIMPLEFB=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_DRM=y) ] && CONFIG_DRM=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_DRM_FBDEV_EMULATION=y) ] && CONFIG_DRM_FBDEV_EMULATION=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_DRM_SIMPLEDRM=y) ] || [ $(cat /boot/config-$KERNELVAR | grep CONFIG_DRM_SIMPLEDRM=m) ] && CONFIG_DRM_SIMPLEDRM=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_FRAMEBUFFER_CONSOLE=y) ] && CONFIG_FRAMEBUFFER_CONSOLE=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_VFAT_FS=y) ] && CONFIG_VFAT_FS=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_EFIVAR_FS=y) ] || [ $(cat /boot/config-$KERNELVAR | grep CONFIG_EFIVAR_FS=m) ] && CONFIG_EFIVAR_FS=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_NLS=y) ] && CONFIG_NLS=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_NLS_CODEPAGE_437=y) ] && CONFIG_NLS_CODEPAGE_437=true
	[ $(cat /boot/config-$KERNELVAR | grep CONFIG_NLS_ISO8859_1=y) ] && CONFIG_NLS_ISO8859_1=true

	[ ! $CONFIG_EFI ] && RETURN=169 && echo "ERROR: CONFIG_EFI is not enabled in the kernel" && return
	[ ! $CONFIG_EFI_STUB ] && RETURN=169 && echo "ERROR: CONFIG_EFI_STUB is not enabled in the kernel" && return
	[ ! $CONFIG_BLOCK ] && RETURN=169 && echo "ERROR: CONFIG_BLOCK is not enabled in the kernel" && return
	[ ! $CONFIG_PARTITION_ADVANCED ] && RETURN=169 && echo "ERROR: CONFIG_PARTITION_ADVANCED is not enabled in the kernel" && return
	[ ! $CONFIG_EFI_PARTITION ] && RETURN=169 && echo "ERROR: CONFIG_EFI_PARTITION is not enabled in the kernel" && return
	[ ! $CONFIG_SYSFB_SIMPLEFB ] && RETURN=169 && echo "ERROR: CONFIG_SYSFB_SIMPLEFB is not enabled in the kernel" && return
	[ ! $CONFIG_DRM ] && RETURN=169 && echo "ERROR: CONFIG_DRM is not enabled in the kernel" && return
	[ ! $CONFIG_DRM_FBDEV_EMULATION ] && RETURN=169 && echo "ERROR: CONFIG_DRM_FBDEV_EMULATION is not enabled in the kernel" && return
	[ ! $CONFIG_DRM_SIMPLEDRM ] && RETURN=169 && echo "ERROR: CONFIG_DRM_SIMPLEDRM is not enabled in the kernel" && return
	[ ! $CONFIG_FRAMEBUFFER_CONSOLE ] && RETURN=169 && echo "ERROR: CONFIG_FRAMEBUFFER_CONSOLE is not enabled in the kernel" && return
	[ ! $CONFIG_VFAT_FS ] && RETURN=169 && echo "ERROR: CONFIG_VFAT_FS is not enabled in the kernel" && return
	[ ! $CONFIG_EFIVAR_FS ] && RETURN=169 && echo "ERROR: CONFIG_EFIVAR_FS is not enabled in the kernel" && return
	[ ! $CONFIG_NLS ] && RETURN=169 && echo "ERROR: CONFIG_NLS is not enabled in the kernel" && return
	[ ! $CONFIG_NLS_CODEPAGE_437 ] && RETURN=169 && echo "ERROR: CONFIG_NLS_CODEPAGE_437 is not enabled in the kernel" && return
	[ ! $CONFIG_NLS_ISO8859_1 ] && RETURN=169 && echo "ERROR: CONFIG_NLS_ISO8859_1 is not enabled in the kernel" && return


	mkdir -pv /usr/share/fonts/unifont
	gunzip -c ../$(basename $PKG_UNIFONT) > /usr/share/fonts/unifont/unifont.pcf

	if [[ "$LFS_VERSION" == "12.2" ]]; then
		unset {C,CPP,CXX,LD}FLAGS
		
		echo depends bli part_gpt > grub-core/extra_deps.lst
	fi

	./configure --prefix=/usr        \
				--sysconfdir=/etc    \
				--disable-efiemu     \
				--enable-grub-mkfont \
				--with-platform=efi  \
				--target=x86_64      \
				--disable-werror
	# --enable-grub-mkfont: Build the tool named grub-mkfont to generate the font file for the boot loader from the font data we've installed.
	# --with-platform=efi: Ensures building GRUB with EFI enabled.
	# --target=x86_64: Ensures building GRUB for x86_64 even if building on a 32-bit LFS system. Most EFI firmware on x86_64 does not support 32-bit bootloaders.
	# --target=i386: A few 32-bit x86 platforms have EFI support. And, some x86_64 platforms have a 32-bit EFI implementation, but they are very old and rare. Use this instead of --target=x86_64 if you are absolutely sure that LFS is running on such a system.

	unset TARGET_CC
	make

	make install
	mv /etc/bash_completion.d/grub /usr/share/bash-completion/completions

	grub-install --target=x86_64-efi --removable

	#mountpoint /sys/firmware/efi/efivars ||  mount -t efivarfs efivarfs /sys/firmware/efi/efivars

	grub-install --bootloader-id=$OS_ID --recheck

fi