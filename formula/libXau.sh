#!/bin/bash

URL="http://xorg.freedesktop.org/releases/individual/lib/libXau-1.0.7.tar.bz2"

DEPEND=(
	"xproto"
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
installed "xau.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
