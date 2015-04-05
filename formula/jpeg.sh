#!/bin/bash

GV_url="http://jpegclub.org/support/files/jpegsrc.v8d1.tar.gz"
GV_sha1="13553b2dba20cb059b10c74ddd00f5395e4f9cee"

GV_depend=()

FU_tools_get_names_from_url
GV_version="8d1"
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
	)
	
	FU_file_get_download
	FU_file_extract_tar

	GV_dir_name="jpeg-8d1"
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_pkg_file "-ljpeg"
	FU_build_finishinstall
fi
