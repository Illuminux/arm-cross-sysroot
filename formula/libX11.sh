#!/bin/bash

URL="http://xorg.freedesktop.org/releases/individual/lib/libX11-1.5.0.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--disable-composecache"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "x11.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi

#export CFLAGS="${CFLAGS} -I${PREFIX}/include/X11"
#export CPPFLAGS=$CFLAGS
#export CXXFLAGS=$CPPFLAGS
