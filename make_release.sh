#!/bin/bash

if [ -f ./templates/etc__sysconfig__ifconfig.* ]; then
	rm -f ./templates/etc__sysconfig__ifconfig.*
fi
if [ -f ./static/etc__profile ]; then
	rm -f ./static/etc__profile
fi
if [ -f ./static/etc__sysconfig__clock ]; then
	rm -f ./static/etc__sysconfig__clock
fi
if [ -f ./static/etc__sysconfig__console ]; then
	rm -f ./static/etc__sysconfig__console
fi
if [ -f ./static/etc__sysconfig__rc.site ]; then
	rm -f ./static/etc__sysconfig__rc.site
fi
if [ -f ./static/etc__syslog.conf ]; then
	rm -f ./static/etc__syslog.conf
fi
if [ -f ./static/etc__inittab ]; then
	rm -f ./static/etc__inittab
fi
if [ -f ./templates/etc__sysconfig__ifconfig.* ]; then
	rm -f ./templates/etc__sysconfig__ifconfig.*
fi
if [ -f ./templates/etc__resolv.conf ]; then
	rm -f ./templates/etc__resolv.conf
fi
if [ -f ./templates/etc__systemd__network__10-eth-static.network ]; then
	rm -f ./templates/etc__systemd__network__10-eth-static.network
fi
if [ -f ./templates/etc__adjtime ]; then
	rm -f ./templates/etc__adjtime
fi
if [ -f ./static/etc__systemd_system_getty@tty1.service.d_noclear.conf ]; then
	rm -f ./static/etc__systemd_system_getty@tty1.service.d_noclear.conf
fi
if [ -f ./static/vconsole.conf ]; then
	rm -f ./static/vconsole.conf
fi
if [ -f ./phase4/build_order.txt ]; then
	rm -f ./phase4/build_order.txt
fi
if [ -f ./templates/etc__fstab ]; then
	rm -f ./templates/etc__fstab
fi
if [ -f ./static/etc__group ]; then
	rm -f ./static/etc__group
fi
if [ -f ./static/etc__passwd ]; then
	rm -f ./static/etc__passwd
fi
if [ -f ./static/etc__ld.so.conf.d__zz_i386-biarch-compat.conf ]; then
	rm -f ./static/etc__ld.so.conf.d__zz_i386-biarch-compat.conf
fi
if [ -f ./static/etc__ld.so.conf.d__zz_x32-biarch-compat.conf ]; then
	rm -f ./static/etc__ld.so.conf.d__zz_x32-biarch-compat.conf
fi
if [ -f ./templates/boot__grub__grub.cfg ]; then
	rm -f ./templates/boot__grub__grub.cfg
fi
if [ -f ./templates/etc__lfs-release ]; then
	rm -f ./templates/etc__lfs-release
fi	
#if [ -f ./templates/etc__*_version ]; then
	rm -f ./templates/etc__*_version
#fi

sed -i "s/export ALWAYS_REBUILD=true/export ALWAYS_REBUILD=false/g" config.sh

rm -f packages*.sh

if [ -f customization_override.sh ]; then
	rm -f customization_override.sh
fi
