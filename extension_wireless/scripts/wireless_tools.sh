# wireless_tools

patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch

make

make PREFIX=/usr INSTALL_MAN=/usr/share/man install
