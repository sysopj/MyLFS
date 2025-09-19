# Jinja2
if [[ "$LFS_VERSION" == "11.2" ]]; then
	pip3 wheel -w dist --no-build-isolation --no-deps $PWD
	pip3 install --no-index --no-user --find-links dist Jinja2
fi


if [[ "$LFS_VERSION" == "12.2" ]] || [[ "$LFS_VERSION" == "12.3" ]] || [[ "$LFS_VERSION" == "12.4" ]]; then
	pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
	pip3 install --no-index --find-links dist Jinja2
fi
