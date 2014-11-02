#!/bin/bash

URL="http://dbus.freedesktop.org/releases/dbus/dbus-1.8.0.tar.gz"

DEPEND=(
	"expat"
	"glib"
)

ARGS=(		
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--host=${HOST}"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)


get_names_from_url
installed "${NAME}-1.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -lgio-2.0 -lgobject-2.0 -lffi -lgmodule-2.0 -ldl -lglib-2.0 -lz -lresolv"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS
fi