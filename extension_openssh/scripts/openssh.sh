# OpenSSH Phase 5
# 12.2 SystemD

install -v -g sys -m700 -d /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
		 
./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run                      &&
make

if $RUN_TESTS
then
    set +e
    make -j1 tests
    set -e
fi

if [ -f /etc/ssh/ssh_host_rsa_key ]; then
	chmod 600 /etc/ssh/ssh_host_rsa_key
fi
if [ -f /etc/ssh/ssh_host_ecdsa_key ]; then
	chmod 600 /etc/ssh/ssh_host_ecdsa_key
fi
if [ -f /etc/ssh/ssh_host_ed25519_key ]; then
	chmod 600 /etc/ssh/ssh_host_ed25519_key
fi

make install

install -v -m755    contrib/ssh-copy-id /usr/bin
install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1
install -v -m755 -d /usr/share/doc/openssh-9.8p1
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-9.8p1
# Configuring OpenSSH
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

#ssh-keygen
#ssh-copy-id -i ~/.ssh/id_ed25519.pub REMOTE_USERNAME@REMOTE_HOSTNAME

echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "KbdInteractiveAuthentication no" >> /etc/ssh/sshd_config

if [ -d /etc/pam.d ]; then
	sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd
	chmod 644 /etc/pam.d/sshd
	echo "UsePAM yes" >> /etc/ssh/sshd_config
fi

pushd ../startupfiles
	make install-sshd
popd

chmod 644 /etc/ssh/moduli
chmod 600 /etc/ssh/ssh_host_ecdsa_key
chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub
chmod 600 /etc/ssh/ssh_host_ed25519_key
chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
chmod 600 /etc/ssh/ssh_host_rsa_key
chmod 644 /etc/ssh/ssh_host_rsa_key.pub

