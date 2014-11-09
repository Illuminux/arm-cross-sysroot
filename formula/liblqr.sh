#!/bin/bash

URL="http://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2"

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
installed "lqr-1.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
	
fi