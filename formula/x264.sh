#!/bin/bash

GV_url="ftp://ftp.videolan.org/pub/x264/snapshots/x264-snapshot-20141114-2245-stable.tar.bz2"
GV_sha1="b6d05c5c788629d18378d9e0942b6605f2460eef"

GV_depend=()

FU_tools_get_names_from_url
GV_version="0.142.x"
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--cross-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--enable-debug"
		"--enable-strip"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install"
	FU_build_finishinstall
fi
