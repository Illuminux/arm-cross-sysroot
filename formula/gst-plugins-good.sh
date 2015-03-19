#!/bin/bash

GV_url="http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.bz2"

DEPEND=(
	"gst-plugins-base"
	"cairo"
	"libjpeg"
	"libpng"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--enable-static"
	"--program-prefix=${UV_target}-"
	"--disable-nls"
	"--disable-examples"
	"--disable-largefile"
	"--disable-gtk-doc"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_tools_get_names_from_url
FU_tools_installed "gstreamer-plugins-good-0.10.pc"

if [ $? == 1 ]; then
	
	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal" "${UV_sysroot_dir}/bin/glib-genmarshal_bak"
	fi
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -ldl -lXv -lXau -lXext -lX11 -lxcb"
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build
	
	unset LIBS
	export LIBS=$TMP_LIBS

	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal_bak" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal_bak" "${UV_sysroot_dir}/bin/glib-genmarshal"
	fi

cat > "${UV_sysroot_dir}/lib/pkgconfig/gstreamer-plugins-good-0.10.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib/gstreamer-0.10
sharedlibdir=\${libdir}
includedir=\${prefix}/include/gstreamer-0.10

Name: ${GV_name}
Description: Streaming media framework, Good plugins libraries
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir}
Cflags: -I\${includedir}
EOF
fi
