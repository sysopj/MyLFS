# Perl Phase 3
PERL_VERSION=$((basename $PKG_PERL .tar.xz) | cut -d "-" -f 2)
PERL_VERSION_1=$(echo $PERL_VERSION | cut -d "." -f 1)
PERL_VERSION_2=$(echo $PERL_VERSION | cut -d "." -f 2)
PERL_VERSION=$PERL_VERSION_1.$PERL_VERSION_2

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	sh Configure -des                                        \
				 -Dprefix=/usr                               \
				 -Dvendorprefix=/usr                         \
				 -Dprivlib=/usr/lib/perl5/$PERL_VERSION/core_perl     \
				 -Darchlib=/usr/lib/perl5/$PERL_VERSION/core_perl     \
				 -Dsitelib=/usr/lib/perl5/$PERL_VERSION/site_perl     \
				 -Dsitearch=/usr/lib/perl5/$PERL_VERSION/site_perl    \
				 -Dvendorlib=/usr/lib/perl5/$PERL_VERSION/vendor_perl \
				 -Dvendorarch=/usr/lib/perl5/$PERL_VERSION/vendor_perl
fi

if [[ "$LFS_VERSION" == "12.2" ]];then
	if ! [ -d /usr/lib/locale ]; then
		mkdir -p /usr/lib/locale
	fi	
	
	localedef -i C -f UTF-8 C.UTF-8
fi

if [[ "$LFS_VERSION" == "12.1" ]] || [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	sh Configure -des                                         \
				 -D prefix=/usr                               \
				 -D vendorprefix=/usr                         \
				 -D useshrplib                                \
				 -D privlib=/usr/lib/perl5/$PERL_VERSION/core_perl     \
				 -D archlib=/usr/lib/perl5/$PERL_VERSION/core_perl     \
				 -D sitelib=/usr/lib/perl5/$PERL_VERSION/site_perl     \
				 -D sitearch=/usr/lib/perl5/$PERL_VERSION/site_perl    \
				 -D vendorlib=/usr/lib/perl5/$PERL_VERSION/vendor_perl \
				 -D vendorarch=/usr/lib/perl5/$PERL_VERSION/vendor_perl
fi

make
make install
