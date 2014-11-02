#!/bin/bash

URL="http://xcb.freedesktop.org/dist/libxcb-1.8.1.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-build-docs"
	"--without-python"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "xcb.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
