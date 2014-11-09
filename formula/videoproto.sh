#!/bin/bash

URL="http://xorg.freedesktop.org/releases/individual/proto/videoproto-2.3.2.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "videoproto.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
