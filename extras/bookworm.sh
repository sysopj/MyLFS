sed -i "s/deb cdrom:/#deb cdrom:/g" /etc/apt/sources.list

apt update && apt upgrade -y

reboot

apt install -y bison gawk  g++-multilib g++ make patch texinfo binutils binutils-dev binutils-i686-gnu binutils-x86-64-linux-gnu binutils-x86-64-linux-gnux32 binutils-multiarch binutils-multiarch-dev binutils-for-host binutils-for-build gcc gcc-multilib fasttrack-archive-keyring gpg smbclient cifs-utils efivar efibootmgr efitools linux-headers-$(uname -r)
# For building a kernel menu:
apt install -y libncurses-dev debhelper flex

cat << EOF >> /etc/smbcredentials
username=XXX
password=YYY
EOF

chmod 400 /etc/smbcredentials
mkdir -pv /mnt/smb/ShareDrive
chmod 765 /mnt/smb/ShareDrive

echo "//192.168.1.50/ShareDrive  /mnt/smb/ShareDrive cifs credentials=/etc/smbcredentials 0 0" >> /etc/fstab

systemctl daemon-reload
mount /mnt/smb/ShareDrive/

#lrwxrwxrwx 1 root root 4 Jan  5  2023 /bin/sh -> dash
unlink /bin/sh
ln -s /bin/bash /bin/sh

wget -O- -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | tee /etc/apt/sources.list.d/virtualbox.list
apt update
apt install virtualbox-7.1

cp /etc/bash.bashrc /root/.bashrc
cp /etc/bash.bashrc /home/sysopj/.bashrc
chown sysopj:sysopj /home/sysopj/.bashrc

[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

passwd lfs

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=x86_64-lfs-linux-gnu
LFS_TGT32=i686-lfs-linux-gnu
LFS_TGTX32=x86_64-lfs-linux-gnux32
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT LFS_TGT32 LFS_TGTX32 PATH
export MAKEFLAGS=-j$(nproc)
EOF

chown lfs:lfs /home/lfs/.bash_profile
chown lfs:lfs /home/lfs/.bashrc

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="syscall.x32=y quiet"/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="syscall.x32=y"/g' /etc/default/grub

update-grub2


#apt install linux-source-6.7 libncurses-dev debhelper flex
#cd /usr/src
#tar -xvf linux-source-6.7.tar.xz
#cd /usr/src/linux-source-6.7/
#make nconfig
#make clean
#make bindeb-pkg
