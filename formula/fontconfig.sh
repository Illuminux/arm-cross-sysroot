#!/bin/bash

URL="http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.9.91.tar.bz2"

DEPEND=(
	"zlib"
	"freetype"
	"expat"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--enable-libxml2"
	"--disable-docs"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "fontconfig.pc"

if [ $? == 1 ]; then
	
	get_download
	extract_tar
	build
	
fi