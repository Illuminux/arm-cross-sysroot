#!/bin/bash

GV_url="http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.bz2"
GV_sha1="b45fc01b133fc23617fa501dd9307a90f467b396"

GV_depend=(
	"gst-plugins-base"
	"cairo"
	"libjpeg"
	"libpng"
)

FU_tools_get_names_from_url
FU_tools_installed "gstreamer-plugins-good-0.10.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lpthread -ldl -lXv -lXau -lXext -lX11 -lxcb -lz -lresolv -lm"

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--enable-static"
		"--disable-nls"
		"--disable-examples"
		"--disable-largefile"
		"--disable-gtk-doc"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	unset LIBS

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
