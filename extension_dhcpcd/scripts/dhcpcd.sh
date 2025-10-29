CURL_VERSION=$((basename $PKG_CURL .tar.xz) | cut -d "-" -f 2)

# Privilege separation
install  -v -m700 -d /var/lib/dhcpcd

[[ $(cat /etc/group | grep dhcpcd) == "" ]] && groupadd -g 52 dhcpcd
[[ $(cat /etc/passwd | grep dhcpcd:) == "" ]] && useradd -c 'dhcpcd PrivSep' \
														 -d /var/lib/dhcpcd  \
														 -g dhcpcd           \
														 -s /bin/false       \
														 -u 52 dhcpcd
chown    -v dhcpcd:dhcpcd /var/lib/dhcpcd 

# Installation of dhcpcd
./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --libexecdir=/usr/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd      \
            --runstatedir=/run           \
            --privsepuser=dhcpcd
make

make install

pushd ../startupfiles
	make install-dhcpcd
popd
