if [[ "$LFSINIT" == "sysvinit" ]]; then
	pushd ..

	mkdir -p startupfiles
	tar -xvf $(basename $PKG_BLFSBOOTSCRIPTS) -C startupfiles --strip-components=1

	popd
fi
