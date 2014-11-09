#!/bin/bash

URL="http://download.osgeo.org/libtiff/tiff-4.0.2.tar.gz"

DEPEND=(
	"zlib"
	"libjpeg"
	"liblzma"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-largefile"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "libtiff-4.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build

	cd $BASE_DIR
	rm -rf "${SYSROOT_DIR}/share"
fi
