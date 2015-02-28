#!/bin/bash

URL="ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng12/libpng-1.2.53.tar.gz"

DEPEND=(
	"zlib"
)

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
installed "${NAME}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
	
	ln -s "${SYSROOT_DIR}/include/libpng12" "${SYSROOT_DIR}/include/libpng"
fi

export CFLAGS="${CFLAGS} -I${SYSROOT_DIR}/include/libpng12"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
