# Man Pages Phase 4
if [[ "$LFS_VERSION" == "12.2" ]];then
	rm -v man3/crypt*
	make prefix=/usr install
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]];then
	rm -v man3/crypt*
	make -R GIT=false prefix=/usr install
fi
