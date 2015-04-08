#!/bin/bash

GV_url="http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.2.tar.bz2"
GV_sha1="4c44da8215d1fc56676fccc1af8dd6b422d9e676"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "vorbis.pc"

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
		"--disable-docs"
		"--disable-example"
		"--disable-oggtest"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
