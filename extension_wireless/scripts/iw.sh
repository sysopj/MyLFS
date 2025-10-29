# iw

sed -i "/INSTALL.*gz/s/.gz//" Makefile &&
make

make install
