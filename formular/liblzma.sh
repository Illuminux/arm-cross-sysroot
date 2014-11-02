#!/bin/bash

URL="http://tukaani.org/xz/xz-5.1.4beta.tar.gz"

ARGS=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-nls"
	"--disable-doc"
	"--disable-scripts"
	"--disable-lzma-links"
	"--disable-lzmainfo"
	"--disable-lzmadec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "liblzma.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi