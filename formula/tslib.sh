#!/bin/bash

URL="http://sourceforge.net/projects/tslib.berlios/files/tslib-1.0.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
	"ac_cv_func_malloc_0_nonnull=yes"
)

get_names_from_url
installed "tslib-0.0.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
