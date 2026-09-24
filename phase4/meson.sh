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

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]] || [[ "$LFS_VERSION" == "13.0" ]] || [[ "$LFS_VERSION" == "13.1" ]]; then
	pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
	pip3 install --no-index --find-links dist meson
fi

install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

if [[ "$MULTILIB" == "true" ]]; then
mkdir -pv /usr/share/meson/cross
mkdir -pv /usr/share/meson/native
for i in {cross/lib32,native/x86}; do
cat > /usr/share/meson/$i << "EOF"
[binaries]
c = ['gcc', '-m32']
cpp = ['g++', '-m32']
rust = ['rustc', '--target', 'i686-unknown-linux-gnu']
pkg-config = 'i686-pc-linux-gnu-pkg-config'
ar = '/usr/bin/ar'
strip = '/usr/bin/strip'
cups-config = 'cups-config'
llvm-config = 'llvm-config'
exe_wrapper = ''

[built-in options]
libdir = 'lib32'

[properties]
sizeof_void* = 4
sizeof_long = 4

[host_machine]
system = 'linux'
subsystem = 'linux'
kernel = 'linux'
cpu_family = 'x86'
cpu = 'i686'
endian = 'little'
EOF
done
fi

if [[ "$MULTILIB" == "true" ]] && [[ "$MULTILIB_mx32" == "true" ]]; then
mkdir -pv /usr/share/meson/cross
mkdir -pv /usr/share/meson/native
for i in {cross/libx32,native/x32}; do
cat > /usr/share/meson/$i << "EOF"
[binaries]
c = ['gcc', '-mx32']
cpp = ['g++', '-mx32']
rust = ['rustc', '--target', 'x86_64-unknown-linux-gnux32']
pkg-config = 'x86_64-unknown-linux-gnux32-pkg-config'
ar = '/usr/bin/ar'
strip = '/usr/bin/strip'
cups-config = 'cups-config'
llvm-config = 'llvm-config'
exe_wrapper = ''

[built-in options]
libdir = 'libx32'

[properties]
sizeof_void* = 4
sizeof_long = 4

[host_machine]
system = 'linux'
subsystem = 'linux'
kernel = 'linux'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
EOF
done
fi