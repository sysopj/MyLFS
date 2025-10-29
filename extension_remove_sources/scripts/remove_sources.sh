
rm -rf /tmp/{*,.*}

find /usr/lib /usr/libexec -name \*.la -delete

rm -r /sources

#find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

[ $(cat /etc/passwd | grep tester) ] && userdel -r tester

# Remove blank lines
sed -i $(cat /etc/group | grep -n "^$" | cut -d \: -f 1)d /etc/group
sed -i $(cat /etc/passwd | grep -n "^$" | cut -d \: -f 1)d /etc/passwd
