# IPRoute2 Phase 4
IPROUTE2_VERSION=$((basename $PKG_IPROUTE2 .tar.xz) | cut -d "-" -f 2)

sed -i /ARPD/d Makefile
rm -f man/man8/arpd.8

if [[ "$LFS_VERSION" == "11.1" ]]; then
	make
fi

if [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "11.3" ]] || [[ "$LFS_VERSION" == "12.0" ]] || [[ "$LFS_VERSION" == "12.1" ]] || [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	make NETNS_RUN_DIR=/run/netns
fi

make SBINDIR=/usr/sbin install

mkdir -p             /usr/share/doc/iproute2-$IPROUTE2_VERSION
cp COPYING README* /usr/share/doc/iproute2-$IPROUTE2_VERSION
