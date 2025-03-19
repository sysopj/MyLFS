# efibootmgr
# The efibootmgr package provides tools and libraries to manipulate EFI variables. 

## Contents
# Installed Programs: efibootdump and efibootmgr

##  Short Descriptions
# efibootdump - is a tool to display individual UEFI boot options, from a file or an UEFI variable
# efibootmgr - is a tool to manipulate the UEFI Boot Manager 



make EFIDIR=$OS_ID EFI_LOADER=grubx64.efi
# EFIDIR=LFS: This option specifies the distro's subdirectory name under /boot/efi/EFI. The building system of this package needs it to be set explicitly.
# EFI_LOADER=grubx64.efi: This option specifies the name of the default EFI boot loader. It is set to match the EFI boot loader provided by GRUB .

make install EFIDIR=$OS_ID
