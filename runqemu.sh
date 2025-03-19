# To fetch $LFS_IMG
source ./config.sh

qemu-system-x86_64 -curses -drive format=raw,file=$LFS_IMG
