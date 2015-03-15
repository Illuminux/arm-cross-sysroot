#!/bin/bash

GV_url="ftp://ftp.gnupg.org/gcrypt//libgcrypt/libgcrypt-1.5.0.tar.bz2"

DEPEND=(
	"libgpg-error"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "${GV_name}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: libgcrypt library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lcrypto
Cflags: -I\${includedir}
EOF
fi
