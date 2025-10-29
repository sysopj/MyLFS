echo "# packages.sh" > extension_openssh/packages.sh
echo "#export PKG_<SCRIPTNAME>=<pkg URL>" >> extension_openssh/packages.sh
echo "export PKG_OPENSSH=openssh-9.8p1.tar.gz" >> extension_openssh/packages.sh

if [[ $LFS_VERSION == "12.4" ]]; then
	echo "export PKG_LINUX=https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.16.1.tar.xz" >> extension_openssh/packages.sh
	echo "export PKG_LINUX_CONFIG=config-6.16.1v5" >> extension_openssh/packages.sh
	echo "linux" >> extension_openssh/build_order.txt
fi
