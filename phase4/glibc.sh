# Glibc Phase 4
if [ -f ../$(basename $PATCH_GLIBC) ]; then
	patch -Np1 -i ../$(basename $PATCH_GLIBC)
fi

mkdir build
cd build

echo "rootsbindir=/usr/sbin" > configparms

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]] && [[ "$MULTILIB" == "false" ]]; then
	../configure --prefix=/usr                            \
				 --disable-werror                         \
				 --enable-kernel=3.2                      \
				 --enable-stack-protector=strong          \
				 --with-headers=/usr/include              \
				 libc_cv_slibdir=/usr/lib
				 
	make

	if $RUN_TESTS
	then
		set +e
		make check
		set -e
	fi

	touch /etc/ld.so.conf
	sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
	make install
	sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
	cp ../nscd/nscd.conf /etc/nscd.conf
	mkdir -p /var/cache/nscd

	mkdir -p /usr/lib/locale
	localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
	localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
	localedef -i de_DE -f ISO-8859-1 de_DE
	localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
	localedef -i de_DE -f UTF-8 de_DE.UTF-8
	localedef -i el_GR -f ISO-8859-7 el_GR
	localedef -i en_GB -f ISO-8859-1 en_GB
	localedef -i en_GB -f UTF-8 en_GB.UTF-8
	localedef -i en_HK -f ISO-8859-1 en_HK
	localedef -i en_PH -f ISO-8859-1 en_PH
	localedef -i en_US -f ISO-8859-1 en_US
	localedef -i en_US -f UTF-8 en_US.UTF-8
	localedef -i es_ES -f ISO-8859-15 es_ES@euro
	localedef -i es_MX -f ISO-8859-1 es_MX
	localedef -i fa_IR -f UTF-8 fa_IR
	localedef -i fr_FR -f ISO-8859-1 fr_FR
	localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
	localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
	localedef -i is_IS -f ISO-8859-1 is_IS
	localedef -i is_IS -f UTF-8 is_IS.UTF-8
	localedef -i it_IT -f ISO-8859-1 it_IT
	localedef -i it_IT -f ISO-8859-15 it_IT@euro
	localedef -i it_IT -f UTF-8 it_IT.UTF-8
	localedef -i ja_JP -f EUC-JP ja_JP
	localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
	localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
	localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
	localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
	localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
	localedef -i se_NO -f UTF-8 se_NO.UTF-8
	localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
	localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
	localedef -i zh_CN -f GB18030 zh_CN.GB18030
	localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
	localedef -i zh_TW -f UTF-8 zh_TW.UTF-8

	tar -xf ../../$(basename $PKG_TZDATA)

	ZONEINFO=/usr/share/zoneinfo
	mkdir -p $ZONEINFO/{posix,right}

	for tz in etcetera southamerica northamerica europe africa antarctica  \
			  asia australasia backward; do
		zic -L /dev/null   -d $ZONEINFO       ${tz}
		zic -L /dev/null   -d $ZONEINFO/posix ${tz}
		zic -L leapseconds -d $ZONEINFO/right ${tz}
	done

	cp zone.tab zone1970.tab iso3166.tab $ZONEINFO
	zic -d $ZONEINFO -p America/New_York
	unset ZONEINFO

	ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	ENABLE_KERNEL=4.19
fi

if [[ "$LFS_VERSION" == "12.3" ]]; then
	ENABLE_KERNEL=5.4
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	../configure --prefix=/usr                        \
             --disable-werror                         \
             --enable-kernel=$ENABLE_KERNEL           \
             --enable-stack-protector=strong          \
             --disable-nscd                           \
             libc_cv_slibdir=/usr/lib
			 
	make

	if $RUN_TESTS
	then
		set +e
		make check
		set -e
	fi

	touch /etc/ld.so.conf
	sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
	make install
	sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
	#cp ../nscd/nscd.conf /etc/nscd.conf
	#mkdir -p /var/cache/nscd

	if ! [ -d /usr/lib/locale ]; then
		mkdir -p /usr/lib/locale
	fi
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then
	localedef -i C -f UTF-8 C.UTF-8
	localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
	localedef -i de_DE -f ISO-8859-1 de_DE
	localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
	localedef -i de_DE -f UTF-8 de_DE.UTF-8
	localedef -i el_GR -f ISO-8859-7 el_GR
	localedef -i en_GB -f ISO-8859-1 en_GB
	localedef -i en_GB -f UTF-8 en_GB.UTF-8
	localedef -i en_HK -f ISO-8859-1 en_HK
	localedef -i en_PH -f ISO-8859-1 en_PH
	localedef -i en_US -f ISO-8859-1 en_US
	localedef -i en_US -f UTF-8 en_US.UTF-8
	localedef -i es_ES -f ISO-8859-15 es_ES@euro
	localedef -i es_MX -f ISO-8859-1 es_MX
	localedef -i fa_IR -f UTF-8 fa_IR
	localedef -i fr_FR -f ISO-8859-1 fr_FR
	localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
	localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
	localedef -i is_IS -f ISO-8859-1 is_IS
	localedef -i is_IS -f UTF-8 is_IS.UTF-8
	localedef -i it_IT -f ISO-8859-1 it_IT
	localedef -i it_IT -f ISO-8859-15 it_IT@euro
	localedef -i it_IT -f UTF-8 it_IT.UTF-8
	localedef -i ja_JP -f EUC-JP ja_JP
	localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
	localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
	localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
	localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
	localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
	localedef -i se_NO -f UTF-8 se_NO.UTF-8
	localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
	localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
	localedef -i zh_CN -f GB18030 zh_CN.GB18030
	localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
	localedef -i zh_TW -f UTF-8 zh_TW.UTF-8
fi

if [[ "$LFS_VERSION" == "12.3" ]]; then
	localedef -i C -f UTF-8 C.UTF-8
	localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
	localedef -i de_DE -f ISO-8859-1 de_DE
	localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
	localedef -i de_DE -f UTF-8 de_DE.UTF-8
	localedef -i el_GR -f ISO-8859-7 el_GR
	localedef -i en_GB -f ISO-8859-1 en_GB
	localedef -i en_GB -f UTF-8 en_GB.UTF-8
	localedef -i en_HK -f ISO-8859-1 en_HK
	localedef -i en_PH -f ISO-8859-1 en_PH
	localedef -i en_US -f ISO-8859-1 en_US
	localedef -i en_US -f UTF-8 en_US.UTF-8
	localedef -i es_ES -f ISO-8859-15 es_ES@euro
	localedef -i es_MX -f ISO-8859-1 es_MX
	localedef -i fa_IR -f UTF-8 fa_IR
	localedef -i fr_FR -f ISO-8859-1 fr_FR
	localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
	localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
	localedef -i is_IS -f ISO-8859-1 is_IS
	localedef -i is_IS -f UTF-8 is_IS.UTF-8
	localedef -i it_IT -f ISO-8859-1 it_IT
	localedef -i it_IT -f ISO-8859-15 it_IT@euro
	localedef -i it_IT -f UTF-8 it_IT.UTF-8
	localedef -i ja_JP -f EUC-JP ja_JP
	localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
	localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
	localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
	localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
	localedef -i se_NO -f UTF-8 se_NO.UTF-8
	localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
	localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
	localedef -i zh_CN -f GB18030 zh_CN.GB18030
	localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
	localedef -i zh_TW -f UTF-8 zh_TW.UTF-8
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	make localedata/install-locales
	tar -xf ../../$(basename $PKG_TZDATA)

	ZONEINFO=/usr/share/zoneinfo
	mkdir -p $ZONEINFO/{posix,right}

	for tz in etcetera southamerica northamerica europe africa antarctica  \
			  asia australasia backward; do
		zic -L /dev/null   -d $ZONEINFO       ${tz}
		zic -L /dev/null   -d $ZONEINFO/posix ${tz}
		zic -L leapseconds -d $ZONEINFO/right ${tz}
	done

	cp zone.tab zone1970.tab iso3166.tab $ZONEINFO
	zic -d $ZONEINFO -p America/New_York
	unset ZONEINFO

	ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]]; then	
	mkdir -p /etc/ld.so.conf.d

	#32 bit
	rm -rf ./*
	find .. -name "*.a" -delete
	
	CC="gcc -m32" CXX="g++ -m32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=i686-pc-linux-gnu           \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=$ENABLE_KERNEL     \
		  --disable-nscd                     \
		  --libdir=/usr/lib32                \
		  --libexecdir=/usr/lib32            \
		  libc_cv_slibdir=/usr/lib32

	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/lib32/* /usr/lib32/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-32.h \
               /usr/include/gnu/
	
	#echo "/usr/lib32" >> /etc/ld.so.conf
	echo "# Legacy biarch compatibility support" > /etc/ld.so.conf.d/zz_i386-biarch-compat.conf
	echo "/libx32" >> /etc/ld.so.conf.d/zz_i386-biarch-compat.conf
	echo "/usr/libx32" >> /etc/ld.so.conf.d/zz_i386-biarch-compat.conf

	#x32 bit
	rm -rf ./*
	find .. -name "*.a" -delete

	CC="gcc -mx32" CXX="g++ -mx32" \
	../configure                             \
		  --prefix=/usr                      \
		  --host=x86_64-pc-linux-gnux32      \
		  --build=$(../scripts/config.guess) \
		  --enable-kernel=$ENABLE_KERNEL     \
		  --disable-nscd                     \
		  --libdir=/usr/libx32               \
		  --libexecdir=/usr/libx32           \
		  libc_cv_slibdir=/usr/libx32

	make
	make DESTDIR=$PWD/DESTDIR install
	cp -a DESTDIR/usr/libx32/* /usr/libx32/
	install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-x32.h \
               /usr/include/gnu/
	
	#echo "/usr/libx32" >> /etc/ld.so.conf	
	echo "# Legacy biarch compatibility support" > /etc/ld.so.conf.d/zz_x32-biarch-compat.conf
	echo "/libx32" >> /etc/ld.so.conf.d/zz_x32-biarch-compat.conf
	echo "/usr/libx32" >> /etc/ld.so.conf.d/zz_x32-biarch-compat.conf
fi


