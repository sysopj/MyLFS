# Texinfo Phase 4

 #Fix a code pattern that causes Perl-5.42 or later to display a warning:
#export PKG_PERL=https://www.cpan.org/src/5.0/perl-5.42.0.tar.xz

PERL_VER=$(basename $PKG_PERL .tar.xz | cut -d "-" -f 2)
PERL_VER_MAJ=$(echo $PERL_VER | cut -d "." -f 1)
PERL_VER_MIN=$(echo $PERL_VER | cut -d "." -f 2)

TEXINFO_VER=$(basename $PKG_TEXINFO | cut -d "-" -f 2)
TEXINFO_VER_MAJ=$(echo $TEXINFO_VER | cut -d "." -f 1)
TEXINFO_VER_MIN=$(echo $TEXINFO_VER | cut -d "." -f 2)

PERL_5_42_FIX_REQ=false
[[ $PERL_VER_MAJ -eq "5" ]] && [[ $PERL_VER_MIN -gt "42" ]] && [[ $TEXINFO_VER_MAJ -eq "7" ]] && [[ $TEXINFO_VER_MIN -eq "2" ]] && PERL_5_42_FIX_REQ=true
[[ $PERL_5_42_FIX_REQ == true ]] && sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm

# if [[ "$LFS_VERSION" == "12.4" ]] || [[ "$LFS_VERSION" == "13.0" ]] || [[ "$LFS_VERSION" == "13.1" ]];then
	# sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm
# fi

./configure --prefix=/usr

if [[ "$LFS_VERSION" == "11.1" ]];then
	sed -e 's/__attribute_nonnull__/__nonnull/' \
		-i gnulib/lib/malloc/dynarray-skeleton.c
fi

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

make TEXMF=/usr/share/texmf install-tex
