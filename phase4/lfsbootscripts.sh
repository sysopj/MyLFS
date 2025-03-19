# LFS Boot Scripts Phase 4
make install

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	# generate network interface name rules
	bash /usr/lib/udev/init-net-rules.sh
fi
