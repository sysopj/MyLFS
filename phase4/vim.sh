# Vim Phase 4
VIM_VERSION=$((basename $PKG_VIM .tar.gz) | cut -d "-" -f 2)

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make

if $RUN_TESTS
then
    set +e
    chown -R tester .
    su tester -c "LANG=en_US.UTF-8 make -j1 test"
    set -e
fi

make install

ln -s vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim90/doc /usr/share/doc/vim-$VIM_VERSION
