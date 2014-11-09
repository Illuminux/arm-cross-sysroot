#!/bin/bash

URL="http://code.entropywave.com/download/orc/orc-0.4.16.tar.gz"

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
	"--datadir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "orc-0.4.pc"

if [ $? == 1 ]; then
	
	get_download
	extract_tar
	build
	
fi