# SQLite Phase 4
SQLITE_VERSION_STRING=$((basename $PKG_SQLITE .tar.gz) | cut -d "-" -f 3)
SQLITE_VERSION_A=$(echo $SQLITE_VERSION_STRING | cut -c 1)
SQLITE_VERSION_B=$(echo $SQLITE_VERSION_STRING | cut -c 2)
SQLITE_VERSION_C=$(echo $SQLITE_VERSION_STRING | cut -c 3)
SQLITE_VERSION_D=$(echo $SQLITE_VERSION_STRING | cut -c 4)
SQLITE_VERSION_E=$(echo $SQLITE_VERSION_STRING | cut -c 5)
SQLITE_VERSION_F=$(echo $SQLITE_VERSION_STRING | cut -c 6)
SQLITE_VERSION_G=$(echo $SQLITE_VERSION_STRING | cut -c 7)

[[ $SQLITE_VERSION_B == 0 ]] && [[ $SQLITE_VERSION_C == 0 ]] && SQLITE_VERSION_2="0"
[[ $SQLITE_VERSION_B == 0 ]] && [[ $SQLITE_VERSION_C != 0 ]] && SQLITE_VERSION_2=$SQLITE_VERSION_C
[[ $SQLITE_VERSION_B != 0 ]] && [[ $SQLITE_VERSION_C != 0 ]] && SQLITE_VERSION_2=${SQLITE_VERSION_B}${SQLITE_VERSION_C}
[[ $SQLITE_VERSION_D == 0 ]] && [[ $SQLITE_VERSION_E == 0 ]] && SQLITE_VERSION_3=""
[[ $SQLITE_VERSION_D == 0 ]] && [[ $SQLITE_VERSION_E != 0 ]] && SQLITE_VERSION_3=$SQLITE_VERSION_E
[[ $SQLITE_VERSION_D != 0 ]] && [[ $SQLITE_VERSION_E != 0 ]] && SQLITE_VERSION_3=${SQLITE_VERSION_D}${SQLITE_VERSION_E}
[[ $SQLITE_VERSION_F == 0 ]] && [[ $SQLITE_VERSION_G == 0 ]] && SQLITE_VERSION_4=""
[[ $SQLITE_VERSION_F == 0 ]] && [[ $SQLITE_VERSION_G != 0 ]] && SQLITE_VERSION_4=$SQLITE_VERSION_G
[[ $SQLITE_VERSION_F != 0 ]] && [[ $SQLITE_VERSION_G != 0 ]] && SQLITE_VERSION_4=${SQLITE_VERSION_F}${SQLITE_VERSION_G}
[[ $SQLITE_VERSION_E == "" ]] && [[ $SQLITE_VERSION_G != "" ]] && SQLITE_VERSION_3=0

#echo SQLITE_VERSION_2=$SQLITE_VERSION_2
#echo SQLITE_VERSION_3=$SQLITE_VERSION_3
#echo SQLITE_VERSION_4=$SQLITE_VERSION_4

SQLITE_VERSION=$SQLITE_VERSION_A.$SQLITE_VERSION_2
#echo $SQLITE_VERSION
[[ $SQLITE_VERSION_3 != "" ]] && SQLITE_VERSION=$SQLITE_VERSION.$SQLITE_VERSION_3
#echo $SQLITE_VERSION
[[ $SQLITE_VERSION_4 != "" ]] && SQLITE_VERSION=$SQLITE_VERSION.$SQLITE_VERSION_4
#echo $SQLITE_VERSION

#[[ $SQLITE_VERSION == 3510200 ]] && SQLITE_VERSION=3.51.2

[[ "$(basename $PKG_SQLITEDOCS | cut -d "." -f 2)" == "zip" ]] && IS_ZIP=true || IS_ZIP=false

$IS_ZIP && SQLITE_DOCS_VERSION=$((basename $PKG_SQLITEDOCS .zip) | cut -d "-" -f 3) || SQLITE_DOCS_VERSION=$((basename $PKG_SQLITEDOCS .tar.xz) | cut -d "-" -f 3)

$IS_ZIP && python3 -m zipfile -e ../$(basename $PKG_SQLITEDOCS) . ||  tar -xf ../$(basename $PKG_SQLITEDOCS)

./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts{4,5} \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"

make LDFLAGS.rpath=""

make install

install -v -m755 -d /usr/share/doc/sqlite-$SQLITE_VERSION
cp -v -R sqlite-doc-${SQLITE_DOCS_VERSION}/* /usr/share/doc/sqlite-$SQLITE_VERSION

if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean

CC="gcc -m32" CXX="g++ -m32"         \
./configure --prefix=/usr            \
            --libdir=/usr/lib32      \
            --host=i686-pc-linux-gnu \
            --disable-static         \
            --enable-fts{4,5}        \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"

	make LDFLAGS.rpath=""
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR
fi
if [[ "$MULTILIB" == "true" ]] && [[ "$MULTILIB_mx32" == "true" ]]; then	
	#x32bit
	make distclean

	CC="gcc -mx32" CXX="g++ -mx32"            \
	./configure --prefix=/usr                 \
				--libdir=/usr/libx32          \
				--host=x86_64-pc-linux-gnux32 \
				--disable-static              \
				--enable-fts{4,5}             \
				CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
						  -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
						  -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
						  -D SQLITE_SECURE_DELETE=1"

	make LDFLAGS.rpath=""

	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR
fi