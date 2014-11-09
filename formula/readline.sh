#!/bin/bash

URL="ftp.gnu.org:/pub/gnu/readline/readline-6.0.tar.gz"

DEPEND=(
	"ncurses"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
	"--with-curses"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lncurses"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS

cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${NAME}
Description: GNU Readline Library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lreadline
Cflags: -I\${includedir}
EOF
fi
