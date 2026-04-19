# Intltool Phase 4
INTLTOOL_VERSION=$((basename $PKG_INTLTOOL .tar.gz) | cut -d "-" -f 2)

PERL_VERSION_0=$((basename $PKG_PERL .tar.xz) | cut -d "-" -f 2)
PERL_VERSION_1=$(echo $PERL_VERSION_0 | cut -d "." -f 1)
PERL_VERSION_2=$(echo $PERL_VERSION_0 | cut -d "." -f 2)
PERL_VERSION="$PERL_VERSION_1.$PERL_VERSION_2"

#export PKG_PERL=https://www.cpan.org/src/5.0/perl-5.42.0.tar.xz

PERL_VER=$(basename $PKG_PERL .tar.xz | cut -d "-" -f 2)
PERL_VER_MAJ=$(echo $PERL_VER | cut -d "." -f 1)
PERL_VER_MIN=$(echo $PERL_VER | cut -d "." -f 2)

PERL_5_22_FIX_REQ=false
[[ $PERL_VER_MAJ -ge "5" ]] && [[ $PERL_VER_MIN -ge "22" ]] && PERL_5_22_FIX_REQ=true
[[ $PERL_5_22_FIX_REQ == true ]] && sed -i 's:\\\${:\\\$\\{:' intltool-update.in

# First fix a warning that is caused by perl-5.22 and later:
#sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install
install -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-$INTLTOOL_VERSION/I18N-HOWTO

