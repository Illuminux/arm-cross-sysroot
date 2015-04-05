#!/bin/bash

GV_url="http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.gz"
GV_sha1="83c4f08796030c0a6fa946e20ecc594c7f4c2142"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "gstreamer-0.10.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export LIBS="-lz -llzma -lpthread -lm"

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
		"--disable-tests"
		"--enable-profiling"
		"--disable-largefile"
		"--disable-docbook"
		"--disable-gtk-doc"
		"--disable-parse"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/gstreamer-0.10"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/lib/gstreamer-0.10"
