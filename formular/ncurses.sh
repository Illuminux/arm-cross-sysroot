#!/bin/bash

URL="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datadir=${BASE_DIR}/tmp/share"
	"--mandir=${BASE_DIR}/tmp/share"
	"--infodir=${BASE_DIR}/tmp/info"
	"--with-shared "
	"--enable-pc-files"
	"--disable-big-core"
	"--disable-big-strings"
	"--disable-largefile"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
	
cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${NAME}
Description: Text-based user interfaces library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lncurses
Cflags: -I\${includedir}
EOF
fi
