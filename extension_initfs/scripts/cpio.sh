APP_VERSION=$(basename $PKG_CPIO .tar.bz2)

./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt

# Requires texlive
#make -C doc pdf
#make -C doc ps

make install

#install -v -m755 -d /usr/share/doc/$APP_VERSION/html
#install -v -m644    doc/html/* \
#                    /usr/share/doc/$APP_VERSION/html
#install -v -m644    doc/cpio.{html,txt} \
#                    /usr/share/doc/$APP_VERSION
					
#install -v -m644 doc/cpio.{pdf,ps,dvi} \
#                 /usr/share/doc/$APP_VERSION
				 