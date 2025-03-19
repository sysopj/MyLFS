# GCC Phase 4
GCC_VERSION=$((basename $PKG_GCC .tar.xz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "11.1" ]]; then
	sed -e '/static.*SIGSTKSZ/d' \
		-e 's/return kAltStackSize/return SIGSTKSZ * 4/' \
		-i libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp
fi

if [[ "$MULTILIB" == "true" ]]; then
	sed -e '/m64=/s/lib64/lib/' \
		-e '/m32=/s/m32=.*/m32=..\/lib32$(call if_multiarch,:i386-linux-gnu)/' \
		-i.orig gcc/config/i386/t-linux64
else
	case $(uname -m) in
	  x86_64)
		sed -e '/m64=/s/lib64/lib/' \
			-i.orig gcc/config/i386/t-linux64
	  ;;
	esac
fi

mkdir build
cd build

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	../configure --prefix=/usr            \
				 LD=ld                    \
				 --enable-languages=c,c++ \
				 --disable-multilib       \
				 --disable-bootstrap      \
				 --with-system-zlib
				 
	ulimit -s 32768
	
	make
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "false" ]]; then
	../configure --prefix=/usr            \
				 LD=ld                    \
				 --enable-languages=c,c++ \
				 --enable-default-pie     \
				 --enable-default-ssp     \
				 --enable-host-pie        \
				 --disable-multilib       \
				 --disable-bootstrap      \
				 --disable-fixincludes    \
				 --with-system-zlib
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && [[ "$MULTILIB" == "true" ]]; then
	mlist=m64,m32,mx32
	../configure --prefix=/usr               \
				 LD=ld                       \
				 --enable-languages=c,c++    \
				 --enable-default-pie        \
				 --enable-default-ssp        \
				 --enable-host-pie           \
				 --enable-multilib           \
				 --with-multilib-list=$mlist \
				 --disable-bootstrap         \
				 --disable-fixincludes       \
				 --with-system-zlib
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	make
	
	ulimit -s -H unlimited
	
	sed -e '/cpython/d'               -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
	sed -e 's/no-pic /&-no-pie /'     -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
	sed -e 's/300000/(1|300000)/'     -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
	sed -e 's/{ target nonpic } //' \
		-e '/GOTPCREL/d'              -i ../gcc/testsuite/gcc.target/i386/fentryname3.c
fi

if $RUN_TESTS
then
    set +e
    chown -Rv tester .
    su tester -c "PATH=$PATH make -k check"
    ../contrib/test_summary
    set -e
fi

# Added to fix cc1plus not found
#mkdir -p /usr/lib/gcc/$(gcc -dumpmachine)/$GCC_VERSION/include{,-fixed}

make install

if [[ "$LFS_VERSION" == "11.1" ]]; then
	rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/$GCC_VERSION/include-fixed/bits/
fi

chown -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/$GCC_VERSION/include{,-fixed}
#   /usr/lib/gcc/*linux-gnu/$GCC_VERSION/include{,-fixed}

ln -sr /usr/bin/cpp /usr/lib

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	ln -s gcc.1 /usr/share/man/man1/cc.1
fi

ln -sf ../../libexec/gcc/$(gcc -dumpmachine)/$GCC_VERSION/liblto_plugin.so \
        /usr/lib/bfd-plugins/

mkdir -p /usr/share/gdb/auto-load/usr/lib
mv /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
