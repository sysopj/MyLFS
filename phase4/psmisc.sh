# Psmisc Phase 4

# __stack_chk_guard undefined
# this is due to adding in gcc 
[[ LIBSSP_SUPPORT == true ]] && CC="gcc -W -lssp"  CXX="g++" ./configure --prefix=/usr || \
./configure --prefix=/usr

make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install

