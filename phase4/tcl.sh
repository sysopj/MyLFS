# Tcl Phase 4
tar -xf ../$(basename $PKG_TCLDOCS) --strip-components=1

SRCDIR=$(pwd)
cd unix

if [[ "$LFS_VERSION" == "11.1" ]];then
	./configure --prefix=/usr           \
				--mandir=/usr/share/man
fi

if [[ "$LFS_VERSION" == "11.2" ]];then
	./configure --prefix=/usr           \
				--mandir=/usr/share/man \
				$([ "$(uname -m)" = x86_64 ] && echo --enable-64bit)
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]];then
	./configure --prefix=/usr           \
				--mandir=/usr/share/man \
				--disable-rpath
fi

make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

TDBC_VERSION=$(ls $SRCDIR/unix/pkgs/ | grep tdbc1)
ITCL_VERSION=$(ls $SRCDIR/unix/pkgs/ | grep itcl)

TCL_VERSION_0=$(basename $PKG_TCL -src.tar.gz)
TCL_VERSION_1=$(echo $TCL_VERSION_0 | cut -d "." -f 1)
TCL_VERSION_2=$(echo $TCL_VERSION_0 | cut -d "." -f 2)
TCL_VERSION_3=$(echo $TCL_VERSION_0 | cut -d "." -f 3)
TCL_VERSION=$TCL_VERSION_1.$TCL_VERSION_2
TCL_VERSION_NUM=$(echo $TCL_VERSION | cut -d 'l' -f 2)
TCL_VERSION_NUM_FULL=$TCL_VERSION_NUM.$TCL_VERSION_3

sed -e "s|$SRCDIR/unix/pkgs/$TDBC_VERSION|/usr/lib/$TDBC_VERSION|" \
    -e "s|$SRCDIR/pkgs/$TDBC_VERSION/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/$TDBC_VERSION/library|/usr/lib/$TCL_VERSION|" \
    -e "s|$SRCDIR/pkgs/$TDBC_VERSION|/usr/include|"            \
    -i pkgs/$TDBC_VERSION/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/$ITCL_VERSION|/usr/lib/$ITCL_VERSION|" \
    -e "s|$SRCDIR/pkgs/$ITCL_VERSION/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/$ITCL_VERSION|/usr/include|"            \
    -i pkgs/$ITCL_VERSION/itclConfig.sh

unset SRCDIR

if $RUN_TESTS
then
    set +e
    make test
    set -e
fi

make install

chmod u+w /usr/lib/lib$TCL_VERSION.so

make install-private-headers

ln -sf tclsh$TCL_VERSION_NUM /usr/bin/tclsh

mv /usr/share/man/man3/{Thread,Tcl_Thread}.3

mkdir -p /usr/share/doc/tcl-$TCL_VERSION_NUM_FULL
cp -r  ../html/* /usr/share/doc/tcl-$TCL_VERSION_NUM_FULL
