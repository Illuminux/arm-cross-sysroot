#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/lib/libXau-1.0.7.tar.bz2"
GV_sha1="29c47207fd246425b906f525b2220235ce4cd0f6"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xau.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
