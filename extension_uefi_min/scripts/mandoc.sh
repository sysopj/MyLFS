# efibootmgr
# The efibootmgr package provides tools and libraries to manipulate EFI variables. 

## Contents
# Installed Programs: efibootdump and efibootmgr

##  Short Descriptions
# efibootdump - is a tool to display individual UEFI boot options, from a file or an UEFI variable
# efibootmgr - is a tool to manipulate the UEFI Boot Manager 



make EFIDIR=LFS EFI_LOADER=grubx64.efi

make install EFIDIR=LFS
