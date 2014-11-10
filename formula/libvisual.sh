#!/bin/bash

URL="http://skylink.dl.sourceforge.net/project/libvisual/libvisual/libvisual-0.4.0/libvisual-0.4.0.tar.gz"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--disable-nls"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datadir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "libvisual-0.4.pc"

if [ $? == 1 ]; then
	
	get_download
	extract_tar
	build
	
fi

export CFLAGS="${CFLAGS} -I${SYSROOT_DIR}/include/libvisual-0.4"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS