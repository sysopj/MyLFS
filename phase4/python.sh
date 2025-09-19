# Python Phase 4
PYTHON_VERSION=$((basename $PKG_PYTHON .tar.xz) | cut -d "-" -f 2)

if [[ "$LFS_VERSION" == "11.1" ]]; then
	./configure --prefix=/usr        \
				--enable-shared      \
				--with-system-expat  \
				--with-system-ffi    \
				--with-ensurepip=yes \
				--enable-optimizations
fi

if [[ "$LFS_VERSION" == "11.2" ]]; then
	./configure --prefix=/usr        \
				--enable-shared      \
				--with-system-expat  \
				--with-system-ffi    \
				--enable-optimizations
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	./configure --prefix=/usr        \
				--enable-shared      \
				--with-system-expat  \
				--enable-optimizations
fi

if [[ "$LFS_VERSION" == "12.4" ]]; then
	./configure --prefix=/usr          \
				--enable-shared        \
				--with-system-expat    \
				--enable-optimizations \
				--without-static-libpython
fi

make

if $RUN_TESTS
then
    set +e
    make test TESTOPTS="--timeout 120"
    set -e
fi

make install

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

install -dm755 /usr/share/doc/python-$PYTHON_VERSION/html

if [[ "$LFS_VERSION" == "11.1" ]] || [[ "$LFS_VERSION" == "11.2" ]]; then
	tar --strip-components=1  \
		--no-same-owner       \
		--no-same-permissions \
		-C /usr/share/doc/python-$PYTHON_VERSION/html \
		-xvf ../$(basename $PKG_PYTHONDOCS)
fi

if [[ "$LFS_VERSION" == "12.2" ]]; then		
	tar --no-same-owner \
		-xvf ../$(basename $PKG_PYTHONDOCS)
	cp -R --no-preserve=mode python-$PYTHON_VERSION-docs-html/* \
		/usr/share/doc/python-$PYTHON_VERSION/html
fi

if [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then		
	tar --strip-components=1  \
		--no-same-owner       \
		--no-same-permissions \
		-C /usr/share/doc/python-$PYTHON_VERSION/html \
		-xvf ../$(basename $PKG_PYTHONDOCS)
fi