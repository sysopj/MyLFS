
rm -rf /tmp/{*,.*}

find /usr/lib /usr/libexec -name \*.la -delete

rm -r /sources/

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

[ $(cat /etc/passwd | grep tester) ] && userdel -r tester
