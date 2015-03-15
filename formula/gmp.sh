#!/bin/bash

GV_url="https://gmplib.org/download/gmp/gmp-5.0.5.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--enable-assert"
	"--enable-alloca"
	"--enable-cxx"
	"--enable-fft"
	"--enable-mpbsd"
	"--enable-fat"
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
Description: GNU Multiple Precision Arithmetic Library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lgmp
Cflags: -I\${includedir}
EOF
fi
