#!/bin/bash

URL="http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--enable-static"
	"--program-prefix=${TARGET}-"
	"--disable-nls"
	"--disable-examples"
	"--disable-largefile"
	"--disable-gtk-doc"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "gstreamer-plugins-good-0.1a.pc"
#installed "gstreamer-plugins-good-0.10.pc"

if [ $? == 1 ]; then
	
	if [ -f "${SYSROOT_DIR}/bin/glib-genmarshal" ]; then 
		mv "${SYSROOT_DIR}/bin/glib-genmarshal" "${SYSROOT_DIR}/bin/glib-genmarshal_bak"
	fi
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -ldl -lXv -lXau -lXext -lX11 -lxcb"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS

	if [ -f "${SYSROOT_DIR}/bin/glib-genmarshal_bak" ]; then 
		mv "${SYSROOT_DIR}/bin/glib-genmarshal_bak" "${SYSROOT_DIR}/bin/glib-genmarshal"
	fi

cat > "${SYSROOT_DIR}/lib/pkgconfig/gstreamer-plugins-good-0.10.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib/gstreamer-0.10
sharedlibdir=\${libdir}
includedir=\${prefix}/include/gstreamer-0.10

Name: ${NAME}
Description: Streaming media framework, Good plugins libraries
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir}
Cflags: -I\${includedir}
EOF
fi
