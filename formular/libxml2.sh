#!/bin/bash

URL="ftp://xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz"

DEPEND=(
	"zlib"
	"liblzma"
)


## @TODO Error while compiling with liblzma

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--without-python"
	"--without-lzma"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url

LIBSML2SCR=$DIR_NAME

installed "libxml-2.0.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi

export CFLAGS="${CFLAGS} -I${PREFIX}/include/libxml2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
