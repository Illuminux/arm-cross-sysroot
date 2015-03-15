#!/bin/bash

GV_url="http://www.mpfr.org/mpfr-current/mpfr-3.1.2.tar.bz2"

DEPEND=(
	"gmp"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--enable-gmp-internals"
	"--enable-assert"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	
	FU_get_download
	FU_extract_tar
	FU_build

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: mpfr library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lmpfr
Cflags: -I\${includedir}
EOF
fi
