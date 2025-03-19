# GMP Phase 4
GMP_VERSION=$((basename $PKG_GMP .tar.xz) | cut -d "-" -f 2)

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-$GMP_VERSION

make
make html

if [[ "$LFS_VERSION" == "11.2" ]] && $RUN_TESTS; then
	set +e
	make check 
	set -e
fi

if [[ "$LFS_VERSION" == "11.2" ]]; then
	if $RUN_TESTS
	then
		set +e
		make check 
		set -e
		
		PASS_COUNT=$(awk '/# PASS:/{total+=$3} ; END{print total}' gmp.log)
		if [ "$PASS_COUNT" != "" ];
		then
			echo "ERROR: GMP tests failed. Check /sources/stage6/gmp_test.log for more info."
			exit -1
		fi
	fi
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	if $RUN_TESTS
	then
		set +e
		make check 2>&1 | tee gmp-check-log
		set -e

		PASS_COUNT=$(awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log)
		if [ "$PASS_COUNT" != "" ];
		then
			echo "ERROR: GMP tests failed. Check /sources/stage6/gmp_test.log for more info."
			exit -1
		fi
	fi
fi

make install
make install-html
	
if [[ "$MULTILIB" == "true" ]]; then
	#32 bit
	make distclean
	
	cp -v configfsf.guess config.guess
	cp -v configfsf.sub   config.sub

	ABI="32" \
	CFLAGS="-m32 -O2 -pedantic -fomit-frame-pointer -mtune=generic -march=i686" \
	CXXFLAGS="$CFLAGS" \
	PKG_CONFIG_PATH="/usr/lib32/pkgconfig" \
	./configure                      \
		--host=i686-pc-linux-gnu     \
		--prefix=/usr                \
		--disable-static             \
		--enable-cxx                 \
		--libdir=/usr/lib32          \
		--includedir=/usr/include/m32/gmp
	
	sed -i 's/$(exec_prefix)\/include/$\(includedir\)/' Makefile
	make
	
	if $RUN_TESTS
	then
		set +e
		make check 
		set -e
	fi
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/lib32/* /usr/lib32
	cp -Rv DESTDIR/usr/include/m32/* /usr/include/m32/
	rm -rf DESTDIR

	#x32 bit
	make distclean
	
	cp -v configfsf.guess config.guess
	cp -v configfsf.sub   config.sub

	ABI="x32" \
	CFLAGS="-mx32 -O2 -pedantic -fomit-frame-pointer -mtune=generic -march=x86-64" \
	CXXFLAGS="$CFLAGS" \
	PKG_CONFIG_PATH="/usr/libx32/pkgconfig" \
	./configure                       \
		--host=x86_64-pc-linux-gnux32 \
		--prefix=/usr                 \
		--disable-static              \
		--enable-cxx                  \
		--libdir=/usr/libx32          \
		--includedir=/usr/include/mx32/gmp
	
	sed -i 's/$(exec_prefix)\/include/$\(includedir\)/' Makefile
	make
	
	if $RUN_TESTS
	then
		set +e
		make check 
		set -e
	fi
	
	make DESTDIR=$PWD/DESTDIR install
	cp -Rv DESTDIR/usr/libx32/* /usr/libx32
	cp -Rv DESTDIR/usr/include/mx32/* /usr/include/mx32/
	rm -rf DESTDIR
fi