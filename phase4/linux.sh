# LINUX Phase 4

CONFIGFILE=config-$KERNELVERS

make mrproper


if [[ $(cat arch/x86/kernel/process.c | grep "EXPORT_SYMBOL(__stack_chk_guard);") == "" ]]; then
cat << EOF > ./process.patch
diff -ruN orig/arch/x86/kernel/process.c new/arch/x86/kernel/process.c
--- orig/arch/x86/kernel/process.c      2025-11-05 23:57:08.410119082 -0500
+++ new/arch/x86/kernel/process.c       2025-11-05 23:56:56.694142634 -0500
@@ -57,6 +57,10 @@

 #include "process.h"

+#if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
+unsigned long __stack_chk_guard __read_mostly;
+EXPORT_SYMBOL(__stack_chk_guard);
+#endif
+
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
EOF
patch -Np1 -i process.patch
fi

if [ -f /boot/$CONFIGFILE ]
then
    cp /boot/$CONFIGFILE .config
    make #olddefconfig
else
    make defconfig

	# Multilib Support
	if [[ "$MULTILIB" == "true" ]]; then
		sed -i "s/# CONFIG_IA32_EMULATION_DEFAULT_DISABLED is not set/CONFIG_IA32_EMULATION_DEFAULT_DISABLED=y/g" .config
		sed -i "s/# CONFIG_X86_X32_ABI is not set/CONFIG_X86_X32_ABI=y/g" .config
		# <M>   IA32 a.out support
	fi
fi

#yes "" | make

make modules_install
#make headers_install

cp ./.config /boot/$CONFIGFILE
cp arch/x86_64/boot/bzImage /boot/vmlinuz-$KERNELVERS
cp System.map /boot/System.map-$KERNELVERS

install -d /usr/share/doc/linux-$KERNELVERS
cp -r Documentation/* /usr/share/doc/linux-$KERNELVERS

[[ $DISK_BOOT != "0" ]] && chmod 0755 /usr/sbin/mkinitramfs
[[ $DISK_BOOT != "0" ]] && mkinitramfs $KERNELVERS && cp initrd.img-$KERNELVERS /boot/
