# ISL Phase 4
ISL_VERSION=$((basename $PKG_ISL .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/isl-$ISL_VERSION

make

make install
install -vd /usr/share/doc/isl-$ISL_VERSION
install -m644 doc/{CodingStyle,manual.pdf,SubmittingPatches,user.pod} \
        /usr/share/doc/isl-$ISL_VERSION
		
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/libisl*gdb.py /usr/share/gdb/auto-load/usr/lib