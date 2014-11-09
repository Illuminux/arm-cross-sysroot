#!/bin/bash

URL="http://sqlite.org/2014/sqlite-autoconf-3080700.tar.gz"

DEPEND=(
	"readline"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-largefile"
	"--enable-readline"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "sqlite3.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
