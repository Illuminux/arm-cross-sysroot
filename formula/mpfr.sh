#!/bin/bash

URL="http://www.mpfr.org/mpfr-current/mpfr-3.1.2.tar.bz2"

DEPEND=(
	"gmp"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--enable-gmp-internals"
	"--enable-assert"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
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
Description: mpfr library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lmpfr
Cflags: -I\${includedir}
EOF
fi
