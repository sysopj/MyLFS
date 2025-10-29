# libnl

# GCC15=""
# GXX15=""
# [ $(gcc -dumpversion | cut -d "." -f 1) == 15 ] && GCC15="-std=gnu17" && GXX15="-std=gnu++17"
# [ $(gcc -dumpversion | cut -d "." -f 1) == 15 ] && GCC15="-std=gnu20" && GXX15="-std=gnu++20"
# [ $(gcc -dumpversion | cut -d "." -f 1) == 15 ] && GCC15="-std=gnu23" && GXX15="-std=gnu++23"

# CC="gcc $GCC15" CXX="g++ $GXX15"	\
./configure --prefix=/usr     		\
            --sysconfdir=/etc 		\
            --disable-static
make

make install

mkdir -vp /usr/share/doc/$(basename $PKG_LIBNL .tar.gz)
tar -xf ../$(basename $PKG_LIBNL_DOC) --strip-components=1 --no-same-owner \
    -C  /usr/share/doc/$(basename $PKG_LIBNL .tar.gz)
