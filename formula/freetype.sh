#!/bin/bash

URL="http://download.savannah.gnu.org/releases/freetype/freetype-2.4.9.tar.bz2"

DEPEND=(
	"zlib"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--without-bzip2"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "freetype2.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi

export CFLAGS="${CFLAGS} -I${SYSROOT_DIR}/include/freetype2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
