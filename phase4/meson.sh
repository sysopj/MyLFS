# Meson Phase 4
if [[ "$LFS_VERSION" == "11.1" ]]; then
	python3 setup.py build

	python3 setup.py install --root=dest
	cp -r dest/* /
fi

if [[ "$LFS_VERSION" == "11.2" ]]; then
	pip3 wheel -w dist --no-build-isolation --no-deps $PWD
	pip3 install --no-index --find-links dist meson
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
	pip3 install --no-index --find-links dist meson
fi

install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
