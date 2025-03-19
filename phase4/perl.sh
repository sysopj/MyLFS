# Perl Phase 4
PERL_VERSION_0=$((basename $PKG_PERL .tar.xz) | cut -d "-" -f 2)
PERL_VERSION_1=$(echo $PERL_VERSION_0 | cut -d "." -f 1)
PERL_VERSION_2=$(echo $PERL_VERSION_0 | cut -d "." -f 2)
PERL_VERSION="$PERL_VERSION_1.$PERL_VERSION_2"

export BUILD_ZLIB=False
export BUILD_BZIP2=0

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	sh Configure -des                                         \
				 -Dprefix=/usr                                \
				 -Dvendorprefix=/usr                          \
				 -Dprivlib=/usr/lib/perl5/$PERL_VERSION/core_perl      \
				 -Darchlib=/usr/lib/perl5/$PERL_VERSION/core_perl      \
				 -Dsitelib=/usr/lib/perl5/$PERL_VERSION/site_perl      \
				 -Dsitearch=/usr/lib/perl5/$PERL_VERSION/site_perl     \
				 -Dvendorlib=/usr/lib/perl5/$PERL_VERSION/vendor_perl  \
				 -Dvendorarch=/usr/lib/perl5/$PERL_VERSION/vendor_perl \
				 -Dman1dir=/usr/share/man/man1                \
				 -Dman3dir=/usr/share/man/man3                \
				 -Dpager="/usr/bin/less -isR"                 \
				 -Duseshrplib                                 \
				 -Dusethreads
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	sh Configure -des                                          \
				 -D prefix=/usr                                \
				 -D vendorprefix=/usr                          \
				 -D privlib=/usr/lib/perl5/$PERL_VERSION/core_perl      \
				 -D archlib=/usr/lib/perl5/$PERL_VERSION/core_perl      \
				 -D sitelib=/usr/lib/perl5/$PERL_VERSION/site_perl      \
				 -D sitearch=/usr/lib/perl5/$PERL_VERSION/site_perl     \
				 -D vendorlib=/usr/lib/perl5/$PERL_VERSION/vendor_perl  \
				 -D vendorarch=/usr/lib/perl5/$PERL_VERSION/vendor_perl \
				 -D man1dir=/usr/share/man/man1                \
				 -D man3dir=/usr/share/man/man3                \
				 -D pager="/usr/bin/less -isR"                 \
				 -D useshrplib                                 \
				 -D usethreads
fi

make

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]] && $RUN_TESTS; then
    set +e
    make test
    set -e
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] && $RUN_TESTS; then
    set +e
    TEST_JOBS=$(nproc) make test_harness
    set -e
fi

make install

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	unset BUILD_ZLIB BUILD_BZIP2
fi
