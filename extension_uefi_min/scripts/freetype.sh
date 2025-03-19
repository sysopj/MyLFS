# FreeType
# The FreeType2 package contains a library which allows applications to properly render TrueType fonts. 

## Contents
# Installed Programs: freetype-config
# Installed Library: libfreetype.so
# Installed Directories: /usr/include/freetype2 and /usr/share/doc/freetype-2.13.3

## Short Descriptions
# freetype-config - is used to get FreeType compilation and linking information
# libfreetype.so - contains functions for rendering various font types, such as TrueType and Type1 

FREETYPE_VERSION=$((basename $PKG_FREETYPE .tar.xz) | cut -d "-" -f 2)

tar -xf ../$(basename $DOC_FREETYPE) --strip-components=2 -C docs

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
#  sed -ri ...: First command enables GX/AAT and OpenType table validation and second command enables Subpixel Rendering. Note that Subpixel Rendering may have patent issues. Be sure to read the 'Other patent issues' part of https://freetype.org/patents.html before enabling this option.


./configure --prefix=/usr --enable-freetype-config --disable-static &&
# --enable-freetype-config: This switch ensure that the man page for freetype-config is installed.
# --without-harfbuzz: If harfbuzz is installed prior to freetype without freetype support, use this switch to avoid a build failure.
# --disable-static: This switch prevents installation of static versions of the libraries. 

make

# As Root

make install

cp -v -R docs -T /usr/share/doc/freetype-$FREETYPE_VERSION &&
rm -v /usr/share/doc/freetype-$FREETYPE_VERSION/freetype-config.1
