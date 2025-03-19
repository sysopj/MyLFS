# Sysvinit Phase 4
if [ -f ../$(basename $PATCH_SYSVINIT) ]; then
	patch -Np1 -i ../$(basename $PATCH_SYSVINIT)
fi

make

make install

