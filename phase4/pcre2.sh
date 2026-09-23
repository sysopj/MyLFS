DESCRIPTION="Generation 2 of the Perl Compatible Regular Expression libraries"
# pcre2
# The PCRE2 package contains a new generation of the Perl Compatible Regular Expression libraries. These are useful for implementing regular expression pattern matching using the same syntax and semantics as Perl.

# Contents
# Installed Programs: pcre2-config, pcre2grep, and pcre2test.
# Installed Libraries: libpcre2-8.so, libpcre2-16.so, libpcre2-32.so, and libpcre2-posix.so
# Installed Directory: /usr/share/doc/pcre2-10.42

# Short Descriptions
# pcre2grep - is a version of grep that understands Perl compatible regular expressions.
# pcre2test - can test a Perl compatible regular expression.
# pcre2-config - outputs compilation information to programs linking against the PCRE2 libraries

# Optional
# Valgrind-3.22.0 and libedit

VERSION_EXT=$(basename $PKG_PCRE2 .tar.bz2 | cut -d "-" -f 2)

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-$VERSION_EXT \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static
# --enable-unicode: This switch enables Unicode support and includes the functions for handling UTF-8/16/32 character strings in the library.
# --enable-pcre2-16: This switch enables 16 bit character support.
# --enable-pcre2-32: This switch enables 32 bit character support.
# --enable-pcre2grep-libz: This switch adds support for reading .gz compressed files to pcre2grep.
# --enable-pcre2grep-libbz2: This switch adds support for reading .bz2 compressed files to pcre2grep.
# --enable-pcre2test-libreadline: This switch adds line editing and history features to the pcre2test program.
# --disable-static: This switch prevents installation of static versions of the libraries.
# --enable-jit: this option enables Just-in-time compiling, which can greatly speed up pattern matching.			

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

if $MULTILIB
then
	make clean
	CC="gcc -m32" CXX="g++ -m32"			\
	./configure --prefix=/usr				\
			--libdir=/usr/lib32				\
			--host=i686-pc-linux-gnu		\
			--build=$(../scripts/config.guess) \
      --libexecdir=/usr/lib32           \
			--enable-unicode				\
			--enable-jit					\
			--enable-pcre2-16				\
			--enable-pcre2-32				\
			--enable-pcre2grep-libz			\
			--enable-pcre2grep-libbz2		\
			--enable-pcre2test-libreadline	\
			--disable-static

	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -vr DESTDIR/usr/lib32/* /usr/lib32
	rm -rf DESTDIR 
	ldconfig
fi
if $MULTILIB_mx32
then
	make clean
	CC="gcc -mx32" CXX="g++ -mx32"			\
	./configure --prefix=/usr				\
			--libdir=/usr/libx32			\
			--host=x86_64-pc-linux-gnux32	\
			--libexecdir=/usr/libx32        \
			--enable-unicode				\
			--disable-jit					\
			--enable-pcre2-16				\
			--enable-pcre2-32				\
			--enable-pcre2grep-libz			\
			--enable-pcre2grep-libbz2		\
			--enable-pcre2test-libreadline	\
			--disable-static				
			#CFLAGS="-mx32" CXXFLAGS="-mx32" LDFLAGS="-mx32"
			#--build=x86_64-pc-linux-gnux32  \
# why --disable-jit was needed to work
	make
	
	make DESTDIR=$PWD/DESTDIR install
	cp -vr DESTDIR/usr/libx32/* /usr/libx32
	rm -rf DESTDIR 
	ldconfig	
fi
