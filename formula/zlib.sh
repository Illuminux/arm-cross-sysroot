#!/bin/bash

GV_url="http://zlib.net/zlib-1.2.8.tar.gz"
GV_sha1="a4d316c404ff54ca545ea71a27af7dbc29817088"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export CHOST=$UV_target
	export CC="${UV_target}-gcc"

	GV_args=(
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--static"
		"--shared"
	)

	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall

	unset CHOST
	unset CC
fi