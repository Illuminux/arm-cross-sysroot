#!/bin/bash

URL="http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.bz2"

DEPEND=(
	"gstreamer"
	"glib"
	"libogg"
	"libtheora"
	"libvorbis"
	"liborc"
	"libvisual"
	"libxml2"
	"zlib"
)

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-nls"
	"--disable-examples"
	"--disable-largefile"
	"--disable-gtk-doc"
	"--disable-app"
	"--disable-alsa" # alsa mixer?
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datadir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "gstreamer-plugins-base-0.10.pc"

if [ $? == 1 ]; then
	
	if [ -f "${SYSROOT_DIR}/bin/glib-genmarshal" ]; then 
		mv "${SYSROOT_DIR}/bin/glib-genmarshal" "${SYSROOT_DIR}/bin/glib-genmarshal_bak"
	fi
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -ldl"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS

	if [ -f "${SYSROOT_DIR}/bin/glib-genmarshal_bak" ]; then 
		mv "${SYSROOT_DIR}/bin/glib-genmarshal_bak" "${SYSROOT_DIR}/bin/glib-genmarshal"
	fi
fi
