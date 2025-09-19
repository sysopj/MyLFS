APP_VERSION=$(basename $PKG_CPIO .tar.bz2)

if [[ "$LFS_VERSION" == "12.4" ]]; then
	sed -e "/^extern int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
		-i src/extern.h
	sed -e "/^int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
		-i src/global.c
fi

./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt

# Requires texlive
#make -C doc pdf
#make -C doc ps

make

#makeinfo --html            -o doc/html      doc/cpio.texi &&
#makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
#makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi

make install

#install -v -m755 -d /usr/share/doc/$APP_VERSION/html
#install -v -m644    doc/html/* \
#                    /usr/share/doc/$APP_VERSION/html
#install -v -m644    doc/cpio.{html,txt} \
#                    /usr/share/doc/$APP_VERSION
					
#install -v -m644 doc/cpio.{pdf,ps,dvi} \
#                 /usr/share/doc/$APP_VERSION
				 