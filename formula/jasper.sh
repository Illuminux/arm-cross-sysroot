#!/bin/bash

GV_url="http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip"
GV_sha1="9c5735f773922e580bf98c7c7dfda9bbed4c5191"

GV_depend=()

FU_tools_get_names_from_url
GV_version="1.900.1"
FU_tools_installed "${LV_formula%;*}.pc"

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
		"--enable-debug"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	GV_dir_name=${GV_tar_name%.zip*}
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
	GV_extension=${GV_tar_name##*.}

	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
	PKG_libs="-ljasper"
	
	FU_build_pkg_file 
	FU_build_finishinstall
fi
