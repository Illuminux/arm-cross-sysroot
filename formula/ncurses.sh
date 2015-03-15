#!/bin/bash

GV_url="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz"

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
	"--datadir=${GV_base_dir}/tmp/share"
	"--mandir=${GV_base_dir}/tmp/share"
	"--infodir=${GV_base_dir}/tmp/info"
	"--with-shared "
	"--enable-pc-files"
	"--disable-big-core"
	"--disable-big-strings"
	"--disable-largefile"
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
Description: Text-based user interfaces library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lncurses
Cflags: -I\${includedir}
EOF
fi
