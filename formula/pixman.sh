#!/bin/bash

URL="http://xorg.freedesktop.org/releases/individual/lib/pixman-0.26.0.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-mmx"
	"--disable-sse2"
	"--disable-vmx"
	"--disable-arm-iwmmxt"
	"--disable-mips-dspr2"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "pixman-1.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
