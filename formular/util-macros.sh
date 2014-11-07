#!/bin/bash

URL="http://xorg.freedesktop.org/releases/individual/util/util-macros-1.16.2.tar.bz2"

ARGS=(
	"--host=${HOST}"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${SYSROOT_DIR}/lib"
)

get_names_from_url
installed "xorg-macros.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
