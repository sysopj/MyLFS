# LINUX Phase 4

CONFIGFILE=config-$KERNELVERS

make mrproper


if [[ $(cat arch/x86/entry/entry.S | grep "EXPORT_SYMBOL(__stack_chk_guard);") == "" ]] && [[ LIBSSP_SUPPORT == true ]]; then
cat << EOF > ./entry.patch
--- orig/arch/x86/entry/entry.S 2025-11-06 18:33:54.754511712 -0500
+++ new/arch/x86/entry/entry.S  2025-11-06 18:33:31.542582299 -0500
@@ -67,4 +67,5 @@
  */
 #if defined(CONFIG_STACKPROTECTOR) && defined(CONFIG_SMP)
 EXPORT_SYMBOL(__ref_stack_chk_guard);
+EXPORT_SYMBOL(__stack_chk_guard);
 #endif
EOF
patch -Np1 -i entry.patch
fi

if [ -f /boot/$CONFIGFILE ]
then
    cp /boot/$CONFIGFILE .config
    #make #olddefconfig
else
    make defconfig

	# Multilib Support
	if [[ "$MULTILIB" == "true" ]]; then
		sed -i "s/# CONFIG_IA32_EMULATION_DEFAULT_DISABLED is not set/CONFIG_IA32_EMULATION_DEFAULT_DISABLED=y/g" .config
		sed -i "s/# CONFIG_X86_X32_ABI is not set/CONFIG_X86_X32_ABI=y/g" .config
		# <M>   IA32 a.out support
	fi
fi

yes "" | make

make modules_install
#make headers_install

cp ./.config /boot/$CONFIGFILE
cp arch/x86_64/boot/bzImage /boot/vmlinuz-$KERNELVERS
cp System.map /boot/System.map-$KERNELVERS

install -d /usr/share/doc/linux-$KERNELVERS
cp -r Documentation/* /usr/share/doc/linux-$KERNELVERS

[[ $DISK_BOOT != "0" ]] && chmod 0755 /usr/sbin/mkinitramfs
[[ $DISK_BOOT != "0" ]] && mkinitramfs $KERNELVERS && cp initrd.img-$KERNELVERS /boot/
