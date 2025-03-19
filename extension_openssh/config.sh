echo "# packages.sh" > extension_openssh/packages.sh
echo "#export PKG_<SCRIPTNAME>=<pkg URL>" >> extension_openssh/packages.sh
echo "export PKG_OPENSSH=openssh-9.8p1.tar.gz" >> extension_openssh/packages.sh

if [[ $LFS_VERSION == "12.2" ]]; then
	echo "export PKG_BLFSSYSTEMD=https://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20240801.tar.xz" >> extension_openssh/packages.sh
	echo "export PKG_BLFSBOOTSCRIPTS=https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20240416.tar.xz" >> extension_openssh/packages.sh
fi

if [[ $LFS_VERSION == "12.3" ]]; then
	echo "export PKG_BLFSSYSTEMD=https://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20241211.tar.xz" >> extension_openssh/packages.sh
	echo "export PKG_BLFSBOOTSCRIPTS=https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20250225.tar.xz" >> extension_openssh/packages.sh
fi