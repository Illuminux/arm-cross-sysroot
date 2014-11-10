#!/bin/bash

URL="http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.gz"

DEPEND=(
	"glib"
	"libxml2"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-nls"
	"--disable-examples"
	"--disable-tests"
	"--disable-loadsave"
	"--disable-largefile"
	"--disable-docbook"
	"--disable-gtk-doc"
	"--disable-parse"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "gstreamer-0.10.pc"

if [ $? == 1 ]; then
	
	if [ -f "${SYSROOT_DIR}/bin/glib-genmarshal" ]; then 
		mv "${SYSROOT_DIR}/bin/glib-genmarshal" "${SYSROOT_DIR}/bin/glib-genmarshal_bak"
	fi
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread"
	
	get_download
	extract_tar
	build

	unset LIBS
	export LIBS=$TMP_LIBS

	if [ -f "${SYSROOT_DIR}/bin/glib-genmarshal_bak" ]; then 
		mv "${SYSROOT_DIR}/bin/glib-genmarshal_bak" "${SYSROOT_DIR}/bin/glib-genmarshal"
	fi
fi

export CFLAGS="${CFLAGS} -I${SYSROOT_DIR}/include/gstreamer-0.10"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
export LDFLAGS="${LDFLAGS} -L${SYSROOT_DIR}/lib/gstreamer-0.10"
