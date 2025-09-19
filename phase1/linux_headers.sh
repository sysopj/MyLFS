# Linux API headers Phase 1
make mrproper

if [[ "$LFS_VERSION" == "10.0" ]] || [[ "$LFS_VERSION" == "10.1" ]] || [[ "$LFS_VERSION" == "11.0" ]] || [[ "$LFS_VERSION" == "11.0" ]] || [[ "$LFS_VERSION" == "11.1" ]];then
	make headers
	find usr/include -name '.*' -delete
	rm usr/include/Makefile
	cp -rv usr/include $LFS/usr
fi

if [[ "$LFS_VERSION" == "11.2" ]] || [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]];then
	make headers
	find usr/include -type f ! -name '*.h' -delete
	cp -rv usr/include $LFS/usr
fi
