#!/bin/bash

URL="http://www.libraw.org/data/LibRaw-0.14.8.tar.gz"

DEPEND=(
	"lcms2"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--enable-lcms"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "libraw.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
