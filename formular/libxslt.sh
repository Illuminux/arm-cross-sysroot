#!/bin/bash

URL="ftp://xmlsoft.org/libxml2/libxslt-1.1.27.tar.gz"

DEPEND=(
	"libxml2"
	"libgcrypt"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--with-libxml-src=${SOURCE_DIR}/${LIBSML2SCR}"
	"--without-python"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
