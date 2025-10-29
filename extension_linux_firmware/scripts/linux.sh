# LINUX Phase 4

make mrproper

cp ../$PKG_LINUX_CONFIG .config

# Multilib Support
if [[ "$MULTILIB" == "true" ]]; then
	sed -i "s/# CONFIG_IA32_EMULATION_DEFAULT_DISABLED is not set/CONFIG_IA32_EMULATION_DEFAULT_DISABLED=y/g" .config
	sed -i "s/# CONFIG_X86_X32_ABI is not set/CONFIG_X86_X32_ABI=y/g" .config
	# <M>   IA32 a.out support
fi

make

make modules_install

cp .config ${LFS}/boot/config-$KERNELVERS
cp arch/x86_64/boot/bzImage ${LFS}/boot/vmlinuz-$KERNELVERS
cp System.map ${LFS}/boot/System.map-$KERNELVERS

# install -d /usr/share/doc/linux-$KERNELVERS
# cp -r Documentation/* /usr/share/doc/linux-$KERNELVERS

[[ $DISK_BOOT != "0" ]] && chmod 0755 ${LFS}/usr/sbin/mkinitramfs
[[ $DISK_BOOT != "0" ]] && mkinitramfs $KERNELVERS && cp initrd.img-$KERNELVERS /boot/
