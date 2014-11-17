#!/bin/bash

URL="http://jpegclub.org/support/files/jpegsrc.v8d1.tar.gz"

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
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "jpeg.pc"

if [ $? == 1 ]; then
	
	get_download
	extract_tar

	DIR_NAME="jpeg-8d1"
	NAME=${DIR_NAME%-*}
	VERSION=${DIR_NAME##$NAME*-}
	
	build

cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${NAME}
Description: jpeg library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -ljpeg
Cflags: -I\${includedir}
EOF
fi
