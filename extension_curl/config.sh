echo "# packages.sh" > extension_openssh/packages.sh
echo "#export PKG_<SCRIPTNAME>=<pkg URL>" >> extension_openssh/packages.sh

if [[ $LFS_VERSION == "12.2" ]] || [[ $LFS_VERSION == "12.3" ]] || [[ $LFS_VERSION == "12.4" ]] || [[ $LFS_VERSION == "13.0" ]]; then
	echo "export PKG_CURL=https://curl.se/download/curl-8.9.1.tar.xz" >> extension_openssh/packages.sh
fi

if [[ $LFS_VERSION == "13.1" ]]; then
	echo "export PKG_CURL=https://curl.se/download/curl-8.21.0.tar.xz" >> extension_openssh/packages.sh
fi
