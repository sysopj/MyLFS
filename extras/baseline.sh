# 12.3 Base:
#	sharedrivec
#	Python Modules

#	make-ca
#	Pearl Modules
#	General Libraires

# Summary:
#	dosfstools			missing nothing
#	#mandoc				missing 
#	efivar				missing mandoc
#	popt				missing doxygen
#	efibootmgr			missing nothing
#	freetype			missing harfbuzz, libpng, which, brotli, librsvg
#	grub				missing fuse, lvm2
#	openssh				missing linux_pam, xorg build env, mit_kerberos_v5
#	cpio				missing texlive
#	curl				missing libpsl, make_ca, brotli, c_ares, gnutls, libidn2, libssh2, mit_kerberos_v5, nghttp2, openldap

##########
## Phase 1
#		ALLOW_GRAPHICS=false
#		INSTALL_RECOMMENDED=false
#		INSTALL_OPTIONAL=false
#		INSTALL_TESTS=false
#		RUN_TESTS=false
##########

echo "watch -n 1 tail -n 59 /etc/extension/installed_version.list" > ~/watch.sh && chmod +x ~/watch.sh
echo "#//10.0.69.121/ShareDrive /mnt/smb cifs credentials=/etc/win-credentials,file_mode=0755,dir_mode=0755,vers=3.1.1 0 0" >> /etc/fstab

curl -4 -L --insecure https://repo.dillonsociety.com/pub/DSLsq/portholes/0.2/extension.sh -o /bin/extension &> /dev/null && chmod +x /bin/extension && extension -u && source ~/.bashrc

cat << 'EOF' > ~/swap.sh
[[ $(ping -c 1 10.0.69.121 | grep "rtr01.dket15.local") != "" ]] && SET_LOCATION=OFFICE || SET_LOCATION=HOME

# Error Detection
[[ $(cat /etc/fstab | grep "#//10.0.69.121") != "" ]] && isFstabSetOffice=true || isFstabSetOffice=false
[[ $(cat /etc/fstab | grep "#//192.168.15.50") != "" ]] && isFstabSetHome=true || isFstabSetHome=false
[[ $isFstabSetOffice == $isFstabSetHome ]] && echo "Corrupt Configs" && exit -1

[[ $isFstabSetOffice == true ]] && fstabLocation=OFFICE || fstabLocation=HOME

[[ $(cat /etc/extension/extension.conf | grep "repo.dillonsociety.com") != "" ]] && confLocation=OFFICE || confLocation=HOME

[[ $SET_LOCATION != $fstabLocation ]] && SWAPFSTAB=true || SWAPFSTAB=false
[[ $SET_LOCATION != $confLocation ]] && SWAPCONF=true || SWAPCONF=false

echo SET_LOCATION=$SET_LOCATION
echo isFstabSetOffice=$isFstabSetOffice
echo isFstabSetHome=$isFstabSetHome
echo confLocation=$confLocation
echo SWAPFSTAB=$SWAPFSTAB
echo SWAPCONF=$SWAPCONF


if [[ $SWAPFSTAB == true ]]; then
	[[ $(cat /etc/fstab | grep "#//10.0.69.121") != "" ]] && sed -i "s@#//10.0.69.121@//10.0.69.121@" /etc/fstab || sed -i "s@//10.0.69.121@#//10.0.69.121@" /etc/fstab
	[[ $(cat /etc/fstab | grep "#//192.168.15.50") != "" ]] && sed -i "s@#//192.168.15.50@//192.168.15.50@" /etc/fstab || sed -i "s@//192.168.15.50@#//192.168.15.50@" /etc/fstab
fi
if [[ $SWAPCONF == true  ]]; then
	[[ $(cat /etc/extension/extension.conf | grep "repo.dillonsociety.com") != "" ]] && sed -i "s@repo.dillonsociety.com@repo.dillonsociety.intranet@" /etc/extension/extension.conf || sed -i "s@repo.dillonsociety.intranet@repo.dillonsociety.com@" /etc/extension/extension.conf
fi

mount /mnt/smb
EOF
chmod +x ~/swap.sh

cat << 'EOF' > ~/logs.sh
while true; do
	tail -n 1 /var/local/extension/logs/extension_*/*.log
	sleep 1
done
EOF
chmod +x ~/logs.sh

extension --install bash_shell_startup_files:12.3
extension --install startup_files:13.0
extension --install which:2.23
extension --install talloc:2.4.3 #docbook4-xml-4.5, docbook-xsl-nons-1.79.2 and libxslt-1.1.42 (To generate man pages), GDB-16.2, git-2.48.1, libnsl-2.0.1, libtirpc-1.3.6, Valgrind-3.24.0, and xfsprogs-6.13.0
extension --install cifs_utils:7.2 #MIT Kerberos V5-1.21.3, docutils-0.21.2 (to create the man pages), keyutils-1.6.3 (required to build PAM module), Linux-PAM-1.7.0, Samba-4.21.4, and libcap-2.73 with PAM
extension --install sharedrivec:1.0
vi /etc/win-credentials

./swap.sh
#cp -vr --no-clobber /mnt/smb/sources/* /var/local/extension/sources/

sed -i "s/        unset HISTFILE/        #unset HISTFILE/g" /etc/profile

systemctl daemon-reload


# systemctl --version
# systemd 259 (259.1) 
# -PAM -AUDIT -SELINUX -APPARMOR +IMA +IPE +SMACK -SECCOMP -GCRYPT -GNUTLS +OPENSSL +ACL +BLKID -CURL -ELFUTILS -FIDO2 -IDN2 -IDN +KMOD -LIBCRYPTSETUP -LIBCRYPTSETUP_PLUGINS +LIBFDISK -PCRE2 
# -PWQUALITY -P11KIT -QRENCODE -TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -BPF_FRAMEWORK -BTF -XKBCOMMON +UTMP +SYSVINIT -LIBARCHIVE


# Goal: 
#	sharedrivec
# Summary:
#	cifs_utils			missing MIT_Kerberos_V5, keyutils, Linux_PAM, Samba, libcap
#	talloc				missing docbook4-xml, docbook-xsl-nons, libxslt, GDB, git, libnsl, libtirpc, Valgrind, xfsprogs

##########
## Phase 2
#		ALLOW_GRAPHICS=false
#		INSTALL_RECOMMENDED=false
#		INSTALL_OPTIONAL=false
#		INSTALL_TESTS=false
#		RUN_TESTS=false
##########

extension --install rsync:3.4.1 #popt, doxygen
extension --install linux:6.18.10 --rebuild #just to get entry
extension --install dosfstools:4.2 --rebuild #just to get entry
extension --install efivar:39 --rebuild
reboot
extension --install cracklib:2.10.3
extension --install nettle:3.10.1
extension --install tripwire:2.4.3.7
extension --install jfsutils:1.1.15
extension --install mdadm:4.3
extension --install nano:8.3
extension --install dash:0.5.12
extension --install apr:1.7.5
extension --install py_cython:3.0.12
extension --install py_packaging:25.0
extension --install py_pyproject_metadata:0.9.0
extension --install patchelf:0.18.0
extension --install py_meson_python:0.17.1
extension --install py_numpy:2.2.3 #fortran from GCC
extension --install boost:1.87.0
extension --install fftw:3.3.10
extension --install inih:58
extension --install jansson:2.14
extension --install lsb_tools:0.12
extension --install keyutils:1.6.3
extension --install libaio:0.3.113
extension --install libatasmart:0.19
extension --install libatomic_ops:7.8.2
extension --install hwdata:0.392
extension --install libdisplay_info:0.2.0
extension --install libgpg_error:1.51
extension --install liblinear:248
extension --install libpaper:2.2.6
extension --install libsigsegv:2.14
extension --install log4cplus:2.1.2
extension --install libstatgrab:0.92.1
extension --install liburcu:0.15.1
extension --install lzo:2.10
extension --install mtdev:1.1.7
extension --install aspell:0.60.8.1
extension --install npth:1.8
extension --install nspr:4.36
extension --install pcre2:10.45 #Valgrind
extension --install xapian:1.4.27
extension --install cmake:4.1.0 #libarchive-3.7.7, libuv-1.50.0, and nghttp2-1.64.0, GCC-14.2.0 (for gfortran), sphinx-8.2.1 (for building documents)
extension --install fmt:11.1.4
extension --install abseil_cpp:20250127.0
extension --install brotli:1.1.0
extension --install c_ares:1.34.4
extension --install protobuf:29.3
extension --install uchardet:0.0.8
extension --install utfcpp:4.0.6
extension --install clucene:2.3.3.4
extension --install double_conversion:3.3.1
extension --install duktape:2.7.0
extension --install gmmlib:22.5.5
extension --install highway:1.2.0
extension --install libptytty:2.0
extension --install git:2.48.1	#Tk-8.6.16 (gitk, a simple Git repository viewer, uses Tk at runtime), Valgrind-3.24.0
extension --install doxygen:1.13.2	#qt, Graphviz-12.2.1, ghostscript-10.04.0, LLVM-19.1.7 (with clang), texlive-20240312 (or install-tl-unx)
extension --install libusb:1.0.27
extension --install libyaml:0.2.5	#Doxygen
extension --install protobuf_c:1.5.1
extension --install popt:1.19 --rebuild # To Add Doxygen Support
extension --install efibootmgr:18 --rebuild # To Add To Installed.txt
extension --install icu:76.1
extension --install libxml2:2.13.6 #Valgrind
extension --install libqalculate:5.5.1
extension --install libarchive:3.7.7
extension --install sqlite:3.49.1
extension --install py_roman_numerals_py:3.1.0
extension --install py_alabaster:1.0.0
extension --install py_pytz:2025.1
extension --install py_babel:2.17.0
extension --install py_docutils:0.21.2	#Docs
extension --install py_imagesize:1.4.1
extension --install py_editables:0.5
extension --install py_pathspec:0.12.1
extension --install py_setuptools_scm:8.1.0
extension --install py_pluggy:1.5.0
extension --install py_trove_classifiers:2025.1.15.22
extension --install py_hatchling:1.27.0
extension --install py_pygments:2.19.1
extension --install py_charset_normalizer:3.4.1
extension --install py_idna:3.10
extension --install py_hatch_vcs:0.4.0
extension --install py_urllib3:2.3.0
extension --install py_certifi:2025.1.31
extension --install py_mako:1.3.9
extension --install py_markdown:3.7
extension --install py_iniconfig:2.0.0
extension --install py_pytest:8.3.4
extension --install py_snowballstemmer:2.2.0
extension --install py_sphinxcontrib_applehelp:2.0.0
extension --install py_sphinxcontrib_devhelp:2.0.0
extension --install py_sphinxcontrib_htmlhelp:2.1.0
extension --install py_sphinxcontrib_jsmath:1.0.1
extension --install py_sphinxcontrib_qthelp:2.0.0
extension --install py_sphinxcontrib_serializinghtml:2.0.0
extension --install py_requests:2.32.3
extension --install py_sphinx:8.2.1	#Docs
extension --install py_sphinxcontrib_jquery:4.1
extension --install py_sphinx_rtd_theme:3.0.2
extension --install py_smartypants:2.0.1
extension --install py_typogrify:2.1.0
extension --install py_gi_docgen:2025.3
extension --install gsl:2.8
extension --install libuv:1.50.0
extension --install docbook4_xml:4.5	#Docs
extension --install itstool:2.0.7	#Docs
extension --install libevent:2.1.12
extension --install nghttp2:1.64.0
extension --install zip:3.0
extension --install node_js:22.22.0
extension --install libgcrypt:1.11.0	#texlive
extension --install docbook_xsl_nons:1.79.2	#Docs
extension --install docbook_xsl_ns:1.79.2	#Docs Java
extension --install libxslt:1.1.42
extension --install gc:8.2.8
extension --install libunistring:1.3 #texlive
extension --install guile:3.0.10
extension --install gdb:16.2 #Valgrind
extension --install glib:2.84.0	#gtk_doc, valgrind
extension --install gtk_doc:1.34.0	#Docs - needs glib 
extension --install shared_mime_info:2.4 #xmlto
extension --install desktop_file_utils:0.28 #Emacs
extension --install llvm:20.1.8	#19.1.7 #Graphviz-12.2.1, texlive-20240312, Valgrind-3.24.0
extension --install valgrind:3.24.0 #? did not install.
extension --install glib:2.84.0 --rebuild	#2.82.5 --rebuild #For docs
extension --install gdb:16.2 --rebuild
extension --install gcc:15.2.0	#14.2.0
extension --install cmake:4.1.0 --rebuild	#3.31.5 --rebuild
extension --install py_numpy:2.2.3 --rebuild
extension --install git:2.48.1 --rebuild #xmlto, asciidoc, fcron, tk
extension --install libxml2:2.13.6 --rebuild
extension --install libtasn1:4.20.0
extension --install libpng:1.6.47	#1.6.46
extension --install pixman:0.46.0	#0.44.2
extension --install talloc:2.4.3 --rebuild #libnsl, libtirpc, xfsprogs
extension --install rsync:3.4.1 --rebuild
extension --install nss:3.117
extension --install p11_kit:0.25.5
extension --install make_ca:1.16.1	#1.15

# Goal: 
#	Jellybean Libraries, glib, cmake, llvm, gcc, doxygen, cifs
# Summary:
#	talloc				missing libnsl, libtirpc, xfsprogs
#	cifs_utils			missing MIT_Kerberos_V5, keyutils, Linux_PAM, Samba, libcap
# 	GIT					missing xmlto, asciidoc, fcron, tk
# 	doxygen				missing qt, Graphviz-12.2.1, ghostscript-10.04.0, LLVM-19.1.7 (with clang), texlive-20240312 (or install-tl-unx)
# 	libgcrypt:1.11.0	missing texlive
# 	libunistring		missing texlive
# 	llvm				missing Graphviz (for doc), texlive, valgrind
#	desktop_file_utils	missing Emacs

extension --install libssh2:1.11.1
extension --install rustc:1.89.0	#1.85.0
extension --install rust_bindgen:0.72.1	#0.71.1
extension --install c_bindgen:0.29.0	#0.28.0
extension --install cargo_c:0.10.15	#0.10.11
extension --install linux:6.18.10 --rebuild # Add Rust Support and more drivers
extension --install virtualbox_guest:7.1.8
extension --install py_asciidoc:10.2.1	#Docs
extension --install freetype:2.13.3 --rebuild	#librsvg
#extension --install graphite2:1.3.14 #harfbuzz, texlive
#extension --install harfbuzz:10.4.0	#cairo
extension --install libdrm:2.4.124	#xorg
extension --install cairo:1.18.2	#fontconfig, xorg, ghostscript, librsvg, poppler
extension --install harfbuzz:10.4.0 --rebuild
extension --install xmlto:0.0.29	#fop
extension --install shared_mime_info:2.4 --rebuild
extension --install nasm:2.16.03
extension --install yasm:1.3.0
extension --install libjpeg_turbo:3.0.1
extension --install py_lxml:5.3.1	#Docs
extension --install texlive:20250308	#20240312	#Docs	graphic enviroment, fontconfig,
extension --install graphite2:1.3.14 --rebuild
extension --install graphviz:12.2.1	#pango, xorg, fontconfig, libwebp, ghostscript, librsvg, Poppler, freeglut, swig, openjdk, lua, ruby, tk
extension --install json_c:0.18
extension --install json_glib:1.10.6
extension --install sgml_common:0.6.3
extension --install docbook3_dtd:3.1
extension --install docbook4_dtd:4.5
extension --install libtirpc:1.3.6	#MIT_Kerberos_V5
extension --install libnsl:2.0.1
extension --install opensp:1.5.2
extension --install openjade:1.3.2
extension --install docbook_dsssl:1.79
extension --install docbook_utils:0.6.14
extension --install fontconfig:2.16.0 --rebuild
extension --install git:2.48.1 --rebuild #fcron, tk
#extension --install llvm:20.1.8 --rebuild #broken doc system
extension --install doxygen:1.13.2 --rebuild	#qt, ghostscript
extension --install libunistring:1.3 --rebuild
extension --install libgcrypt:1.11.0 --rebuild
extension --install xfsprogs:6.13.0 --rebuild
extension --install talloc:2.4.3 --rebuild
extension --install cairo:1.18.2 --rebuild #xorg, ghostscript, librsvg, poppler
extension --install texlive:20250308 --rebuild	#graphic enviroment

# Goal: 
#	texlive
# Summary:
#	cifs_utils			missing MIT_Kerberos_V5, keyutils, Linux_PAM, Samba, libcap
# 	GIT					missing fcron, tk
# 	doxygen				missing qt, ghostscript
#	freetype			missing librsvg
#	libdrm				missing xorg
#	graphviz			missing pango, xorg, fontconfig, libwebp, ghostscript, librsvg, Poppler, freeglut, swig, openjdk, lua, ruby, tk
#	libtirpc			missing MIT_Kerberos_V5
#	cairo				missing xorg, ghostscript, librsvg, poppler
#	texlive				missing graphic enviroment
#	desktop_file_utils	missing Emacs

extension --install swig:4.3.0
extension --install libseccomp:2.6.0
extension --install unbound:1.22.0
extension --install libidn2:2.3.7
extension --install gnutls:3.8.9
extension --install cups:2.4.11	#colord, dbus, linux_pam, xdg_utils, avahi, libpaper, mit_kereros_v5, php, cups_filters, gutenprint
extension --install little_cms:2.17	#libtiff
extension --install libtiff:4.7.0	#freeglut, libwebp
extension --install little_cms:2.17 --rebuild
extension --install openjpeg:2.5.3
extension --install libidn:1.42 #emacs, openjdk
extension --install giflib:5.2.2
extension --install libwebp:1.5.0
extension --install libtiff:4.7.1 --rebuild #freeglut
extension --install ghostscript:10.05.1	#10.04.0	#Desktop,  gtk3
extension --install doxygen:1.13.2 --rebuild	#qt
extension --install libyaml:0.2.5 --rebuild
extension --install ruby:3.4.2	#tk
extension --install lua:5.4.7
extension --install vala:0.56.17
extension --install poppler:25.10.0 #GPGME, Qt, gdk-pixbuf, GTK3
extension --install graphviz:12.2.1	--rebuild #pango, xorg, openjdk, tk, librsvg, freeglut
extension --install cairo:1.18.2 --rebuild #xorg, librsvg
extension --install libpsl:0.21.5
extension --install wget:1.25.0

# Goal: 
#	ghostscript
# Summary:
#	cups				missing colord, dbus, linux_pam, xdg_utils, avahi, libpaper, mit_kereros_v5, php, cups_filters, gutenprint
#	cifs_utils			missing MIT_Kerberos_V5, keyutils, Linux_PAM, Samba, libcap
# 	GIT					missing fcron, tk
# 	doxygen				missing qt
#	libdrm				missing xorg
#	libidn				missing emacs, openjdk
#	graphviz			missing pango, xorg, openjdk, tk, librsvg, freeglut
#	libtirpc			missing MIT_Kerberos_V5
#	cairo				missing xorg, librsvg
#	texlive				missing graphic enviroment
#	libwebp				missing sdl2
#	ghostscript			missing graphic enviroment, gtk3
#	ruby				missing tk
#	librsvg				missing gdk-pixbuf, Pango
#	poppler				missing GPGME, Qt, gdk-pixbuf, GTK3
#	libtiff				missing freeglut
#	freetype			missing librsvg
#	desktop_file_utils	missing Emacs

extension --install py_six:1.17.0
extension --install py_psutil:7.0.0
extension --install py_pyyaml:6.0.2
extension --install py_ply:3.11
extension --install py_hatch_fancy_pypi_readme:24.1.0
extension --install py_attrs:25.1.0
extension --install py_chardet:5.2.0
extension --install py_commonmark:0.9.1
extension --install py_msgpack:1.1.0
extension --install py_webencodings:0.5.1
extension --install py_cachecontrol:0.14.2
extension --install py_cssselect:1.2.0
extension --install py_dbus_python:1.3.2
extension --install py_dbusmock:0.34.3
extension --install py_doxypypy:0.8.8.7
extension --install py_doxyqml:0.5.3
extension --install py_html5lib:1.1
extension --install py_py3c:1.4
extension --install py_pycairo:1.26.1
extension --install py_pygdbmi:0.11.0.0 
extension --install py_pygobject:3.50.0
extension --install py_pyparsing:3.2.1
extension --install py_pyserial:3.5
extension --install py_pyxdg:0.28
extension --install py_recommonmark:0.7.1
extension --install py_sentry_sdk:2.22.0
extension --install py_scour:0.38.2
extension --install py_pyproject_hooks:1.2.0
extension --install py_build:1.2.2
extension --install py_installer:0.7.0

extension --install perl:5.42.0
extension --install perl_algorithm_diff:1.201
extension --install perl_b_cow:0.007
extension --install perl_business_isbn_data:20250205.001
extension --install perl_capture_tiny:0.50
extension --install perl_class_data_inheritable:0.10
extension --install perl_class_inspector:1.36
extension --install perl_class_singleton:1.6
extension --install perl_class_tiny:1.008
extension --install perl_clone:0.47
extension --install perl_cpan_meta_check:0.018
extension --install perl_devel_stacktrace:2.05
extension --install perl_encode_locale:1.05
extension --install perl_exception_class:1.45
extension --install perl_exporter_tiny:1.006002
extension --install perl_file_which:1.27
extension --install perl_path_tiny:0.146
extension --install perl_term_table:0.024
extension --install perl_test_simple:1.302209
extension --install perl_ffi_checklib:0.31
extension --install perl_file_chdir:0.1011
extension --install perl_test_deep:1.204
extension --install perl_try_tiny:0.32
extension --install perl_test_fatal:0.017
extension --install perl_test_utf8:1.03
extension --install perl_test_file:1.994
extension --install perl_test_warnings:0.038
extension --install perl_file_copy_recursive:0.45
extension --install perl_file_sharedir_install:0.14
extension --install perl_file_sharedir:1.118
extension --install perl_html_tagset:3.24
extension --install perl_timedate:2.33
extension --install perl_http_date:6.06
extension --install perl_file_listing:6.16
extension --install perl_io_html:1.004
extension --install perl_net_ssleay:1.94
extension --install perl_lwp_mediatypes:6.04
extension --install perl_mime_base32:1.303
extension --install perl_test_needs:0.002010
extension --install perl_business_isbn:3.011
extension --install perl_uri:5.31
extension --install perl_test_requires:0.11
extension --install perl_http_message:7.00
extension --install perl_http_cookies:6.11
extension --install perl_http_negotiate:6.01
extension --install perl_ipc_system_simple:1.30
extension --install perl_list_moreutils_xs:0.430
extension --install perl_module_runtime:0.016
extension --install perl_module_implementation:0.09
extension --install perl_list_someutils_xs:0.58
extension --install perl_list_someutils:0.59
extension --install perl_list_utilsby:0.12
extension --install perl_encode_eucjpascii:0.03
extension --install perl_encode_hanextra:0.23
extension --install perl_encode_jis2k:0.05
extension --install perl_mime_charset:1.013.1
extension --install perl_dist_checkconflicts:0.11
extension --install perl_mro_compat:0.15
extension --install perl_sub_exporter_progressive:0.001013
extension --install perl_variable_magic:0.64
extension --install perl_b_hooks_endofscope:0.28
extension --install perl_package_stash:0.40
extension --install perl_namespace_clean:0.27
extension --install perl_namespace_autoclean:0.31
extension --install perl_net_http:6.23
extension --install perl_number_compare:0.03
extension --install perl_module_build:0.4234
extension --install perl_params_validate:1.31
extension --install perl_eval_closure:0.14
extension --install perl_sub_quote:2.006008
extension --install perl_role_tiny:2.002004
extension --install perl_specio:0.49
extension --install perl_sub_uplevel:0.2800
extension --install perl_test_without_module:0.23
extension --install perl_module_pluggable:6.3
extension --install perl_ipc_run3:0.049
extension --install perl_test2_plugin_nowarnings:0.10
extension --install perl_params_validationcompiler:0.31
extension --install perl_scope_guard:0.21
extension --install perl_test_file_sharedir:1.001002
extension --install perl_datetime_locale:1.44
extension --install perl_datetime_timezone:2.64
extension --install perl_datetime:1.65
extension --install perl_datetime_format_strptime:1.79
extension --install perl_test_exception:0.43
extension --install perl_test_leaktrace:0.17
extension --install perl_test_requiresinternet:0.05
extension --install perl_text_csv_xs:1.60
extension --install perl_text_diff:1.45
extension --install perl_text_glob:0.11
extension --install perl_file_find_rule:0.34
extension --install perl_tie_cycle:1.229
extension --install perl_http_cookiejar:0.014
extension --install perl_www_robotrules:6.02
extension --install perl_alien_build:2.84
extension --install perl_alien_build_plugin_download_gitlab:0.01
extension --install perl_alien_libxml2:0.19
extension --install perl_xml_sax_base:1.09
extension --install perl_xml_namespacesupport:1.12
extension --install perl_xml_sax:1.02
extension --install perl_xml_libxml:2.0210
extension --install perl_archive_zip:1.68
extension --install perl_autovivification:0.18
extension --install perl_business_ismn:1.205	#1.204
extension --install perl_business_issn:1.008
extension --install perl_class_accessor:0.51
extension --install perl_data_compare:1.29
extension --install perl_data_dump:1.25
extension --install perl_data_uniqid:0.12
extension --install perl_datetime_calendar_julian:0.107
extension --install perl_datetime_format_builder:0.83
extension --install perl_file_fcntllock:0.22
extension --install perl_file_slurper:0.014
extension --install perl_config_autoconf:0.320 
extension --install perl_html_parser:3.83
extension --install perl_http_daemon:6.16
extension --install perl_io_socket_ssl:2.089	#fail with internet
extension --install perl_io_string:1.08
extension --install perl_lwp:6.78
extension --install perl_lwp_protocol_https:6.14
extension --install perl_lingua_translit:0.29
extension --install perl_list_allutils:0.19
extension --install perl_list_moreutils:0.430
extension --install perl_log_log4perl:1.57
extension --install perl_extutils_libbuilder:0.09
extension --install perl_net_dns:1.50
extension --install perl_parse_recdescent:1.967015
extension --install perl_parse_yapp:1.21
extension --install perl_perlio_utf8_strict:0.010
extension --install perl_regexp_common:2024080801
extension --install perl_sgmlspm:1.1
extension --install perl_sort_key:1.33
extension --install perl_test_command:0.11
extension --install perl_test_differences:0.71
extension --install perl_text_bibtex:0.91
extension --install perl_text_csv:2.05
extension --install perl_text_roman:3.5
extension --install perl_unicode_collate:1.31
extension --install perl_unicode_linebreak:2019.001
extension --install perl_xml_libxml_simple:1.01
extension --install perl_xml_libxslt:2.003000
extension --install perl_xml_simple:2.25
extension --install perl_xml_writer:0.900
#extension --install py_pyatspi2:2.46.1 #GUI

# Goal: 
#	python & perl scripts
# Summary:
#	cups				missing colord, dbus, linux_pam, xdg_utils, avahi, libpaper, mit_kereros_v5, php, cups_filters, gutenprint
#	cifs_utils			missing MIT_Kerberos_V5, keyutils, Linux_PAM, Samba, libcap
# 	GIT					missing fcron, tk
# 	doxygen				missing qt
#	libdrm				missing xorg
#	libidn				missing emacs, openjdk
#	graphviz			missing pango, xorg, openjdk, tk
#	libtirpc			missing MIT_Kerberos_V5
#	cairo				missing xorg
#	texlive				missing graphic enviroment
##	freeglut			missing mesa, glu
#	libwebp				missing sdl2
#	ghostscript			missing graphic enviroment, gtk3
#	ruby				missing tk
#	librsvg				missing gdk-pixbuf, Pango
#	poppler				missing GPGME, Qt, gdk-pixbuf, GTK3
#	desktop_file_utils	missing Emacs

extension --install java:23.0.2
extension --install alsa_lib:1.2.14	#1.2.13
extension --install sharutils:4.15.2
extension --install lynx:2.9.2
extension --install libdaemon:0.14
extension --install avahi:0.8 #gtk3
extension --install gavl:1.4.0
extension --install apache_ant:1.10.15
extension --install libexif:0.6.25
extension --install jasper:4.2.4 #Freeglut
extension --install opencv:4.12.0	#4.11.0 #ffmpeg, gst_plugins_base, gtk3, v4l_utils, xine_lib
extension --install frei0r_plugins:1.8.0
extension --install fop:2.10
extension --install docbook5_xml:5.0	#Docs
extension --install rpcsvc_proto:1.4.4
extension --install libnvme:1.16.1
extension --install lvm2:2.03.31	#2.03.30
extension --install btrfs_progs:6.13
extension --install asciidoctor:2.0.23
extension --install libpwquality:1.4.5 #linux_pam
#extension --install shadow:4.17.3
#extension --install systemd=257.3
extension --install linux_pam:1.7.0
extension --install libpwquality:1.4.5 --rebuild
extension --install cryptsetup:2.7.5
extension --install libical:3.0.19
extension --install bluez:5.79
extension --install libnl:3.11.0
extension --install libpcap:1.10.5
extension --install iptables:1.8.11
extension --install qrencode:4.1.1
extension --install libunwind:1.8.1
extension --install gstreamer:1.26.6 #gtk3
extension --install cdparanoia_III:10.2
extension --install iso_codes:4.17.0
extension --install libgudev:238
extension --install libogg:1.3.5
extension --install libvorbis:1.3.7
extension --install libassuan:3.0.2 #Why ? texi2dvi cannot proceed without one when making pdf
extension --install exempi:2.6.5
#extension --install dbus:1.16.0 #Xorg_libraires
extension --install dbus_glib:0.112 #dbus
extension --install enchant:2.8.2
extension --install libbytesize:2.12
extension --install libmbim:1.30.0	#1.26.4
extension --install libxmlb:0.3.21
extension --install spirv_headers:1.4.321.0	#1.4.304.1
extension --install spirv_tools:1.4.321.0	#1.4.304.1
extension --install spirv_llvm_translator:20.1.5	#19.1.4
extension --install libclc:19.1.7
extension --install glslang:15.1.0
extension --install lm_sensors:3.6.0
extension --install fribidi:1.0.16
extension --install pango:1.56.1 #xorg_libraries
extension --install graphene:1.10.8
extension --install sassc:3.6.2
extension --install glib_networking:2.80.1 #gsettings-desktop-schemas-47.1
extension --install x264:20250212
extension --install x265:4.1
extension --install libmng:2.0.3
extension --install pciutils:3.14.0	#3.13.0
extension --install libndp:1.9
extension --install libqmi:1.34.0	#1.30.8
extension --install polkit:126 --rebuild #command -v polkitd fails
extension --install libsigcpp2:2.12.1
extension --install glibmm_24:2.66.7
extension --install libsigcpp3:3.6.0
extension --install glibmm_68:2.82.0
extension --install modemmanager:1.22.0	#1.18.12
extension --install upower:1.90.7
extension --install wpa_supplicant:2.11	--rebuild
extension --install slang:2.3.3
extension --install newt:0.52.24
extension --install libcap:2.73
extension --install unixodbc:2.3.12
extension --install lmdb:0.9.31
extension --install cyrus_sasl:2.1.28 #MariaDB-11.4.5 or MySQL, PostgreSQL-17.4, openldap
extension --install openldap:2.6.9 #Cyrus_SASL, MariaDB-11.4.5 or PostgreSQL-17.4
extension --install mit_kerberos_v5:1.22.2 #BIND Utilities-9.20.6, GnuPG-2.4.7
extension --install cups:2.4.11	--rebuild #colord, dbus, xdg_utils, php, cups_filters, gutenprint
extension --install cifs_utils:7.2 --rebuild #Samba
extension --install ntp:4.2.8p18
extension --install dhcpcd:10.2.4 --rebuild	#10.2.2
extension --install mobile_broadband_provider_info:20120614
extension --install networkmanager:1.52.0	#1.50.0
extension --install liboauth:1.0.3
extension --install stunnel:5.74
extension --install sudo:1.9.16p2

useradd -c "James A. Dillon" -m sysopj
# mkhomedir_helper sysopj
usermod -aG wheel sysopj
groupadd -g 109 render
usermod -aG video,render sysopj
cat > /etc/udev/rules.d/70-render.rules << "EOF"
SUBSYSTEM=="drm", KERNEL=="renderD*", GROUP="render", MODE="0660"
EOF

LC_ALL=C.UTF-8
mkdir /tmp/xdg-root

.bash_profile
# Wayland Environment Variables
export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
export KWIN_DRM_NO_AMS=1

extension --install libksba:1.6.7
extension --install fuse:3.16.2
extension --install gnupg:2.4.7 #ImageMagick-7.1.1-43
extension --install clisp:2.49.95	#2.49
extension --install gpgme:2.0.1
extension --install postgresql:17.4
extension --install mit_kerberos_v5:1.22.2 --rebuild #BIND Utilities
extension --install openldap:2.6.9 --rebuild
extension --install cyrus_sasl:2.1.28 --rebuild
extension --install gpgmepp:2.0.0
extension --install poppler:25.10.0 --rebuild #Qt, gdk-pixbuf, GTK3
extension --install libtirpc:1.3.6 --rebuild
extension --install graphviz:12.2.1 --rebuild #xorg, tk
extension --install emacs:30.1	#gtk3
extension --install libidn:1.42 --rebuild
extension --install desktop_file_utils:0.28 --rebuild

# Goal: 
#	MISC
# Summary:
#	avahi				missing gtk3
#	jasper				missing Freeglut
#	opencv				missing ffmpeg, gst_plugins_base, gtk3, v4l_utils, xine_lib
#	gstreamer			missing gtk3
#	dbus_glib			missing dbus
#	pango				missing xorg_libraries
#	glib_networking		missing gsettings-desktop-schemas
#	mit_kerberos_v5		missing BIND Utilities
#	cups				missing colord, dbus, xdg_utils, php, cups_filters, gutenprint
#	cifs_utils			missing Samba
#	gnupg				missing ImageMagick
# 	GIT					missing fcron, tk
# 	doxygen				missing qt
#	libdrm				missing xorg
#	graphviz			missing xorg, tk
#	cairo				missing xorg
#	texlive				missing graphic enviroment
##	freeglut			missing mesa, glu
#	libwebp				missing sdl2
#	ghostscript			missing graphic enviroment, gtk3
#	ruby				missing tk
#	librsvg				missing gdk-pixbuf, Pango
#	poppler				missing Qt, gdk-pixbuf, gtk3
#	emacs				missing gtk3

#enable recommended
sed -i "s/INSTALL_RECOMMENDED=false/INSTALL_RECOMMENDED=true/" /etc/extension/extension.conf
#enable optional
sed -i "s/INSTALL_OPTIONAL=false/INSTALL_OPTIONAL=true/" /etc/extension/extension.conf
#enable graphics
sed -i "s/ALLOW_GRAPHICS=false/ALLOW_GRAPHICS=true/" /etc/extension/extension.conf

#X Org
extension --install xorg_build_env:7.0
extension --install util_macros:1.20.2
extension --install xorgproto:2024.1
extension --install libxau:1.0.12
extension --install libxdmcp:1.1.5
extension --install xcb_proto:1.17.0
extension --install libxcb:1.17.0
# xtrans=1.5.2
# libX11=1.8.11
# libXext=1.3.6
# libFS=1.0.10
# libICE=1.1.2
# libSM=1.2.5
# libXt=1.3.1
# libXScrnSaver=1.2.4
# libXmu=1.2.1
# libXpm=3.5.17
# libXaw=1.0.16
# libXfixes=6.0.1
# libXcomposite=0.4.6
# libXrender=0.9.12
# libXcursor=1.2.3
# libXdamage=1.1.6
# libfontenc=1.1.8
# libXfont2=2.0.7
# libXft=2.3.8
# libXi=1.8.2
# libXinerama=1.1.5
# libXrandr=1.5.4
# libXres=1.2.2
# libXtst=1.2.5
# libXv=1.0.13
# libXvMC=1.0.14
# libXxf86dga=1.1.6
# libXxf86vm=1.1.6
# libpciaccess=0.18.1
# libxkbfile=1.1.3
# libxshmfence=1.3.3
# libXpresent=1.0.1
extension --install xorg_libraries:12.3
extension --install libxcvt:0.1.3
extension --install xcb_util:0.4.1
# extension --install xcb_util_image:0.4.1
# extension --install xcb_util_keysyms:0.4.1
# extension --install xcb_util_renderutil:0.3.10
# extension --install xcb_util_wm:0.4.2
# extension --install xcb_util_cursor:0.1.5
extension --install xcb_utilities:0.4.1
extension --install libdrm:2.4.124 --rebuild
extension --install libva:2.22.0
extension --install libvdpau:1.5
extension --install wayland:1.24.0	#1.23.91
extension --install wayland_protocols:1.45	#1.40
extension --install vulkan_headers:1.4.315
extension --install vulkan_loader:1.4.315
## extension --install glproto:1.4.17 Bad to use
#libx11, glproto and libxext
extension --install libglvnd:1.7.0
extension --install mesa:26.0.1
extension --install xbitmaps:1.1.3
# xbitmaps=1.1.3
# iceauth=1.0.10
# mkfontscale=1.2.3
# sessreg=1.1.3
# setxkbmap=1.3.4
# smproxy=1.0.7
# xauth=1.1.3
# xcmsdb=1.0.7
# xcursorgen=1.0.8
# xdpyinfo=1.3.4
# xdriinfo=1.0.7
# xev=1.2.6
# xgamma=1.0.7
# xhost=1.0.10
# xinput=1.6.4
# xkbcomp=1.4.7
# xkbevd=1.1.6
# xkbutils=1.0.6
# xkill=1.0.6
# xlsatoms=1.1.4
# xlsclients=1.1.5
# xmessage=1.0.7
# xmodmap=1.0.11
# xpr=1.2.0
# xprop=1.2.8
# xrandr=1.5.3
# xrdb=1.2.2
# =	##xrefresh-1.1.0.tar.xz
# xset=1.2.5
# xsetroot=1.1.3
# xvinfo=1.1.5
# xwd=1.0.9
# xwininfo=1.1.6
# xwud=1.0.7
extension --install xorg_applications:12.3
extension --install luit:20240910
extension --install xcursor_themes:1.0.7
# font_util=1.4.1
# encodings=1.1.0
# font_alias=1.0.5
# font=adobe		#####
# font_bh_ttf=1.0.4
# font_bh_type1=1.0.4
# font_ibm_type1=1.0.4
# font_misc_ethiopic=1.0.5
# font_xfree86_type1=1.0.5
extension --install xorg_fonts:12.3
extension --install xkeyboardconfig:2.44
extension --install libepoxy:1.5.10
extension --install libevdev:1.13.3
extension --install libxkbcommon:1.8.0
extension --install libei:1.3.0
extension --install xwayland:24.1.6
extension --install xorg_server:21.1.16
extension --install xorg_vesa_drv:2.6.0
extension --install xorg_vmware_drv:13.4.0
extension --install display_vmware:12.3
#Xorg Input Drivers
extension --install xorg_evdev_drv:2.11.0
extension --install libinput:1.27.1
extension --install xorg_libinput_drv:1.5.0 #1.4.0
extension --install xorg_synaptics_drv:1.10.0
extension --install xorg_wacom_drv:1.2.3
extension --install twm:1.0.12
extension --install xterm:397
extension --install xclock:1.1.1
extension --install xinit:1.4.3

cat > /etc/X11/xorg.conf.d/20-video.conf << "EOF"
Section "Device"
        Identifier	"VirtualBox Graphics"
        Driver  	"vmware"
EndSection
EOF

export DISPLAY=":0"

extension --install gdk_pixbuf:2.42.12
extension --install librsvg:2.61.1	#2.59.2
extension --install cairo:1.18.2 --rebuild #add xorg support
extension --install opus:1.5.2
extension --install sdl2:2.30.11
extension --install gst_plugins_base:1.24.12
extension --install gsettings_desktop_schemas:47.1
extension --install at_spi2_core:2.54.1
extension --install libcloudproviders:0.3.6
extension --install py_pyatspi2:2.46.1
extension --install glib_networking:2.80.1
extension --install libsoup3_0:3.6.4
extension --install tinysparql:3.8.2
extension --install gtk3:3.24.48
extension --install glu:9.0.3
extension --install freeglut:3.6.0
extension --install libwebp:1.5.0 --rebuild
extension --install jasper:4.2.4 --rebuild
extension --install gstreamer:1.26.6 --rebuild
extension --install pango:1.56.1 --rebuild
extension --install ghostscript:10.05.1 --rebuild
extension --install tk:8.6.16
extension --install graphviz:12.2.1 --rebuild
extension --install gpm:1.20.7
extension --install avahi:0.8 --rebuild
extension --install flac:1.5.0
extension --install lame:3.100
extension --install mpg123:1.32.10
extension --install speex:1.2.1
extension --install libsndfile:1.2.2
extension --install libsamplerate:0.2.2
extension --install sbc:2.0
extension --install gst_plugins_base:1.24.12	# why twice?
extension --install pulseaudio:17.0
extension --install libaom:3.12.0
extension --install libass:0.17.3
extension --install fdk_aac:2.0.3
extension --install libvpx:1.15.0
extension --install libvdpau_va_gl:0.4.2
extension --install libcddb:1.3.2
extension --install libcdio:2.1.0
extension --install libavif:1.2.0
extension --install libjxl:0.11.1
extension --install xvid:1.3.7
extension --install dav1d:1.5.3
extension --install svt_av1:3.1.2
extension --install ffmpeg:7.1.2
extension --install libdvdread:6.1.3
extension --install libdvdnav:6.1.1
extension --install xine_lib:1.2.13
extension --install librsvg:2.61.1 --rebuild
extension --install fcron:3.4.0
extension --install git:2.48.1 --rebuild	#gitk --version
extension --install ruby:3.4.2 --rebuild
extension --install qt:6.10.2				# Why it didnt install?
extension --install v4l_utils:1.28.1
extension --install opencv:4.12.0 --rebuild
extension --install poppler:25.10.0 --rebuild #fixed missing Qt, gdk-pixbuf, gtk3

# sane-1.2.1
# imagemagick-7.1.1r43

extension --install extra_cmake_modules:6.17.0
extension --install sddm:0.21.0

mkdir -p /usr/share/xsessions/
cat > /usr/share/xsessions/twm.desktop << "EOF"
[Desktop Entry]
Name=TWM
Comment=Tab Window Manager
Exec=/usr/bin/twm
TryExec=/usr/bin/twm
Type=Application
EOF

extension --install alsa_ucm_conf
extension --install alsa_utils
extension --install phonon:4.12.0
extension --install liba52:0.8.0
extension --install libmad:0.15.1b
extension --install vlc:3.0.21
extension --install phonon_backend_vlc:0.12.0
extension --install polkit_qt:0.200.0
extension --install plasma_wayland_protocols:1.18.0
extension --install kde_breeze_icons:6.17.0
extension --install libcanberra:0.30
extension --install qca:2.3.10
extension --install libsecret:0.21.6
extension --install zxing_cpp:2.3.0
extension --install libraw:0.21.3
extension --install smartmontools:7.4
extension --install libblockdev:3.3.0
#extension --install polkit:126
#extension --install linux_pam:1.7.0
#extension --install qemu:
#extension --install zsh:
extension --install py_lxml:5.3.1
extension --install systemd:259.1		# qemu & zsh
extension --install udisks:2.10.1
extension --install parted:3.6
extension --install libheif:1.20.2
extension --install kde_framework:6.17.0
extension --install 7zip:25.01
extension --install unrar:7.1.5
extension --install kde_ark:25.08.0
extension --install kdsoap:2.2.0
extension --install dconf:0.40.0
extension --install kdsoap_ws_discovery_client:0.4.0
extension --install plasma_activities:6.4.4
extension --install plasma_activities_stats:6.4.4
extension --install qcoro:0.12.0
extension --install exiv2:0.28.5
extension --install libkexiv2:25.08.0
extension --install utfcpp:4.0.6
extension --install taglib:2.0.2
extension --install kde_kio_extras:25.08.0
extension --install kde_dolphin:25.08.0
extension --install kde_dolphin_plugins:25.08.0
extension --install mlt:7.30.0
extension --install libostree:2026.1
extension --install socat:1.8.1.1
extension --install pipewire:1.2.7
#extension --install kde_kdenlive:25.08.0
extension --install kde_kmix:25.08.0
extension --install qtwebengine:6.10.2
extension --install kde_khelpcenter:25.08.0
extension --install kde_konsole:25.08.0
extension --install kde_konversation:25.08.0
extension --install kde_okular:25.08.0
extension --install libraw:0.21.4
extension --install kde_libkdcraw:25.08.0
extension --install kcolorpicker:0.3.1
extension --install kimageannotator:0.7.1
extension --install kde_gwenview:25.08.0
extension --install neon:0.34.0
extension --install libmusicbrainz:5.1.0
extension --install libkcddb:25.08.0
extension --install k3b:25.08.0
extension --install kirigami_addons:1.9.0
extension --install libheif:1.20.2
extension --install pulseaudio_qt:1.7.0
extension --install xdotool:3.20211022.1
extension --install libwacom:2.14.0
extension --install oxygen_icons:6.0.0
extension --install appstream:1.0.4
extension --install kde_plasma:6.4.4
extension --install dbus:1.16.2
extension --install fluxbox:1.3.7
extension --install imlib2:1.12.5
extension --install py_pyatspi2:2.46.1 #why?
extension --install gtk3:3.24.48
extension --install adwaita_icon_theme:47.0
extension --install soundtouch:2.3.3
extension --install faac:1.31.1
extension --install faad2:2.11.2
extension --install glib_networking:2.80.1
extension --install libsoup2_4:2.74.3
extension --install gst_plugins_good:1.26.6
extension --install sdl12_compat_release:1.2.68
extension --install shaderc:2024.4
extension --install gst_plugins_bad:1.26.6
extension --install libgusb:0.4.9
extension --install sane:1.4.0
extension --install colord:1.4.7
extension --install colord_gtk
extension --install xdg_utils:1.2.1
extension --install cups:2.4.11 --rebuild	#php, cups_filters, gutenprint
extension --install gtk4:4.16.12
extension --install gcr4:4.4.0.1
extension --install rest:0.9.1
extension --install totem_pl_parser:3.26.6
extension --install fast_float:8.1.0
extension --install vte:0.80.3
extension --install yelp_xsl:42.4
extension --install libnotify:0.8.6
extension --install geoclue:2.7.2
extension --install glm:1.0.1
extension --install raptor2:2.0.16
extension --install rasqal:0.9.33
extension --install redland:1.0.17