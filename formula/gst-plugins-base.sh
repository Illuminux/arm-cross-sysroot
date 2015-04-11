#!/bin/bash

GV_url="http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.bz2"
GV_sha1="e675401b62a6bf2e5ea966e833afd005a585e978"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "gstreamer-plugins-base-0.10.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export LIBS="-lXv -ldl -lXext -lX11 -lxcb -lXau -lrt -lpthread -lm"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-nls"
		"--disable-examples"
		"--disable-largefile"
		"--disable-gtk-doc"
		"--disable-app"
		"--disable-pango"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi