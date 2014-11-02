#!/bin/bash

URL="http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz"

DEPEND=(
	"libogg"
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
installed "theora.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
