# efivar
# The efivar package provides tools and libraries to manipulate EFI variables.

## Contents
# Installed Programs: efisecdb and efivar
# Installed Library: libefiboot.so, libefisec.so, and libefivar.so
# Installed Directories: /usr/include/efivar

## Short Descriptions
# efisecdb - is an utility for managing UEFI signature lists
# efivar - is a tool to manipulate UEFI variables
# libefiboot.so - is a library used by efibootmgr
# libefisec.so - is a library for managing UEFI signature lists
# libefivar.so - is a library for the manipulation of EFI variables

# In GCC 15, there are 2 possible fixes. 1 is via a patch, 2 is to build using the older standard 'make ENABLE_DOCS=0 CFLAGS="-std=gnu17"'

GCC_FIX_15=false
[[ $(gcc -dumpversion | cut -d "." -f 1) == 15 ]] && GCC_FIX_15=true

if [[ $GCC_FIX_15 == true ]]; then
cat > efivar-39.patch << "EOF"
diff -Naur efivar-39/src/guid.c efivar/src/guid.c
--- efivar-39/src/guid.c	2024-01-31 15:08:46.000000000 -0500
+++ efivar/src/guid.c	2026-03-31 01:25:41.789251306 -0400
@@ -85,7 +85,7 @@
 	memcpy(&key.guid, guid, sizeof(*guid));
 
 	struct efivar_guidname *tmp;
-	tmp = bsearch(&key,
+	tmp = (void *)bsearch(&key,
 		      &efi_well_known_guids[0],
 		      efi_n_well_known_guids,
 		      sizeof(efi_well_known_guids[0]),
@@ -202,7 +202,7 @@
 	key.name[sizeof(key.name) - 1] = '\0';
 
 	struct efivar_guidname *result;
-	result = bsearch(&key,
+	result = (void *)bsearch(&key,
 			 &efi_well_known_names[0],
 			 efi_n_well_known_names,
 			 sizeof(efi_well_known_names[0]),
diff -Naur efivar-39/src/linux-acpi-root.c efivar/src/linux-acpi-root.c
--- efivar-39/src/linux-acpi-root.c	2024-01-31 15:08:46.000000000 -0500
+++ efivar/src/linux-acpi-root.c	2026-03-31 01:29:36.125972089 -0400
@@ -61,7 +61,7 @@
 	if (strlen(current) < 8)
 		return 0;
 
-	colon = strchr(current, ':');
+	colon = (void *)strchr(current, ':');
 	if (!colon)
 		return 0;
 	pos1 = colon - current;
diff -Naur efivar-39/src/linux-ata.c efivar/src/linux-ata.c
--- efivar-39/src/linux-ata.c	2024-01-31 15:08:46.000000000 -0500
+++ efivar/src/linux-ata.c	2026-03-31 01:28:48.189883201 -0400
@@ -95,7 +95,7 @@
 		return 0;
 	}
 
-	char *host = strstr(path, "/host");
+	char *host = (void *)strstr(path, "/host");
 	if (!host)
 		return -1;
 
@@ -113,7 +113,7 @@
 	dev->ata_info.scsi_target = scsi_target;
 	dev->ata_info.scsi_lun = scsi_lun;
 
-	char *block = strstr(current, "/block/");
+	char *block = (void *)strstr(current, "/block/");
 	if (block)
 		current += block + 1 - current;
 	debug("current:'%s' sz:%zd", current, current - path);
diff -Naur efivar-39/src/linux-i2o.c efivar/src/linux-i2o.c
--- efivar-39/src/linux-i2o.c	2024-01-31 15:08:46.000000000 -0500
+++ efivar/src/linux-i2o.c	2026-03-31 01:26:16.005217967 -0400
@@ -32,7 +32,7 @@
 	        return 0;
 	}
 
-	char *block = strstr(current, "/block/");
+	char *block = (void *)strstr(current, "/block/");
 	ssize_t sz = block ? block + 1 - current : -1;
 	debug("current:'%s' sz:%zd", current, sz);
 	return sz;
diff -Naur efivar-39/src/linux.c efivar/src/linux.c
--- efivar-39/src/linux.c	2024-01-31 15:08:46.000000000 -0500
+++ efivar/src/linux.c	2026-03-31 01:29:13.077873471 -0400
@@ -38,7 +38,7 @@
 	char *linkbuf;
 
 	/* strip leading /dev/ */
-	node = strrchr(child, '/');
+	node = (void *)strrchr(child, '/');
 	if (!node)
 	        return -1;
 	node++;
EOF
fi

[ -f efivar-39.patch ] && patch -Np1 -i efivar-39.patch

make ENABLE_DOCS=0

# As Root

make install LIBDIR=/usr/lib ENABLE_DOCS=0
# LIBDIR=/usr/lib: This option overrides the default library directory of the package (/usr/lib64, which is not used by LFS).
# ENABLE_DOCS=0: Disable the generation of man pages. Append this option after the make and make install commands if you don't need the man pages to allow building this package without mandoc-1.14.6 installed.
