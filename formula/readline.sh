#!/bin/bash

GV_url="ftp.gnu.org:/pub/gnu/readline/readline-6.0.tar.gz"

DEPEND=(
	"ncurses"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
	"--with-curses"
)

FU_tools_get_names_from_url
FU_tools_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lncurses"
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build
	
	unset LIBS
	export LIBS=$TMP_LIBS

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: GNU Readline Library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lreadline
Cflags: -I\${includedir}
EOF
fi
