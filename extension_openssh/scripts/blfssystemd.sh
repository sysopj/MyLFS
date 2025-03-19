if [[ "$LFSINIT" == "systemd" ]]; then
	pushd ..

	mkdir -p startupfiles
	tar -xvf $(basename $PKG_BLFSSYSTEMD) -C startupfiles --strip-components=1

	popd
fi
