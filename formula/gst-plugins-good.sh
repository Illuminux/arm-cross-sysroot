#!/bin/bash

GV_url="http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.bz2"
GV_sha1="b45fc01b133fc23617fa501dd9307a90f467b396"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "gstreamer-plugins-good-0.10.pc"

if [ $? == 1 ]; then
	
#	FU_tools_check_depend
	
	export LIBS="-ldl -lm"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--enable-static"
		"--disable-nls"
		"--disable-examples"
		"--disable-gtk-doc"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
	PKG_libs=""
	PKG_includedir="/gstreamer-0.10"
	
	FU_build_pkg_file
	FU_build_finishinstall
fi
