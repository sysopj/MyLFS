# Bzip2 Phase 4
if [ -d ../$(basename $PATCH_BZIP2) ]; then
	patch -Np1 -i ../$(basename $PATCH_BZIP2)
fi

if [ -s /usr/lib/libbz2.so ]; then unlink /usr/lib/libbz2.so; fi

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install

cp -a libbz2.so.* /usr/lib
ln -s libbz2.so.1.0.8 /usr/lib/libbz2.so

cp bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sf bzip2 $i
done

rm -f /usr/lib/libbz2.a

if [[ "$MULTILIB" == "true" ]]; then
	if [ -s /usr/lib32/libbz2.so ]; then unlink /usr/lib32/libbz2.so; fi
	if [ -s /usr/lib32/libbz2.so.1 ]; then unlink /usr/lib32/libbz2.so.1; fi
	if [ -s /usr/lib32/libbz2.so.1.0 ]; then unlink /usr/lib32/libbz2.so.1.0; fi
	
	if [ -s /usr/libx32/libbz2.so ]; then unlink /usr/libx32/libbz2.so; fi
	if [ -s /usr/libx32/libbz2.so.1 ]; then unlink /usr/libx32/libbz2.so.1; fi
	if [ -s /usr/libx32/libbz2.so.1.0 ]; then unlink /usr/libx32/libbz2.so.1.0; fi


	#32 bit
	make clean

	sed -e "s/^CC=.*/CC=gcc -m32/" -i Makefile{,-libbz2_so}
	make -f Makefile-libbz2_so
	make libbz2.a
			
	install -Dm755 libbz2.so.1.0.8 /usr/lib32/libbz2.so.1.0.8
	ln -sf libbz2.so.1.0.8 /usr/lib32/libbz2.so
	ln -sf libbz2.so.1.0.8 /usr/lib32/libbz2.so.1
	ln -sf libbz2.so.1.0.8 /usr/lib32/libbz2.so.1.0
	install -Dm644 libbz2.a /usr/lib32/libbz2.a
	
	#x32 bit
	make clean

	sed -e "s/^CC=.*/CC=gcc -mx32/" -i Makefile{,-libbz2_so}
	make -f Makefile-libbz2_so
	make libbz2.a
	
	install -Dm755 libbz2.so.1.0.8 /usr/libx32/libbz2.so.1.0.8
	ln -sf libbz2.so.1.0.8 /usr/libx32/libbz2.so
	ln -sf libbz2.so.1.0.8 /usr/libx32/libbz2.so.1
	ln -sf libbz2.so.1.0.8 /usr/libx32/libbz2.so.1.0
	install -Dm644 libbz2.a /usr/libx32/libbz2.a
fi
