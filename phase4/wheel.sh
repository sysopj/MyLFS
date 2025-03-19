# Wheel
if [[ "$LFS_VERSION" == "11.2" ]]; then
	pip3 install --no-index $PWD
fi

if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]]; then
	pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

	pip3 install --no-index --find-links=dist wheel
fi
