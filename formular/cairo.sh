#!/bin/bash

URL="http://cairographics.org/releases/cairo-1.12.2.tar.xz"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--enable-xml"
	"--enable-xlib-xcb"
	"--program-prefix=${TARGET}-"
	"--disable-largefile"
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
fi
