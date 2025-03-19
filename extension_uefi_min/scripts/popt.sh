# popt
# The popt package contains the popt libraries which are used by some programs to parse command-line options. 

## Contents
# Installed Programs: None
# Installed Library: libpopt.so
# Installed Directories: /usr/share/doc/popt-1.19

## Short Descriptions
# libpopt.so - is used to parse command-line options


# Check if doxygen is installed
if command -v "doxygen" > /dev/null 2>&1; then DOXYGEN_INSTALLED=true; else DOXYGEN_INSTALLED=false; fi


if [[ $ENABLE_DOXYGEN == "true" ]] && [[ $DOXYGEN_INSTALLED == "false" ]]; then
	echo "WARNING: DOXYGEN is enabled but not installed"
fi

POPT_VERSION=$((basename $PKG_POPT .tar.gz) | cut -d "-" -f 2)

./configure --prefix=/usr --disable-static
# --disable-static: This switch prevents installation of static versions of the libraries. 

make

# If you have doxgen
if [[ $ENABLE_DOXYGEN == "true" ]] && [[ $DOXYGEN_INSTALLED == "true" ]]; then
	sed -i 's@\./@src/@' Doxyfile &&
	doxygen
fi

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

# As Root

make install

if [[ $ENABLE_DOXYGEN == "true" ]] && [[ $DOXYGEN_INSTALLED == "true" ]]; then
	install -v -m755 -d /usr/share/doc/popt-$POPT_VERSION
	install -v -m644 doxygen/html/* /usr/share/doc/popt-$POPT_VERSION
fi
