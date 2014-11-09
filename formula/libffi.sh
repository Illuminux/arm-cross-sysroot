#!/bin/bash

URL="ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
	
	ln -s "${SYSROOT_DIR}/lib/${DIR_NAME}/include/ffi.h"       "${SYSROOT_DIR}/include/"
	ln -s "${SYSROOT_DIR}/lib/${DIR_NAME}/include/ffitarget.h" "${SYSROOT_DIR}/include/"
fi
