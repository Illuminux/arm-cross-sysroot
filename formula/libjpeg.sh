#!/bin/bash

GV_url="http://jpegclub.org/support/files/jpegsrc.v8d1.tar.gz"

DEPEND=()

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
installed "jpeg.pc"

if [ $? == 1 ]; then
	
	get_download
	extract_tar

	GV_dir_name="jpeg-8d1"
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
	
	build

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: jpeg library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -ljpeg
Cflags: -I\${includedir}
EOF
fi
