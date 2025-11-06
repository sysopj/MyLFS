# linux_firmware
#DESCRIPTION="The open source firmware for the Kernel"

#EXT_VERSION=$(basename $PKG_LINUX_FIRMWARE .tar.gz | cut -d "-" -f 3) 

[[ $LFS == "" ]] && exit -1
pushd /usr/lib/firmware
rm -rf *
popd

#sed -i 's@^destdir=$@destdir=/usr/lib/firmware@' copy-firmware.sh
sh copy-firmware.sh --zstd -v /usr/lib/firmware

#update_version_list $PKG_LINUX_FIRMWARE
