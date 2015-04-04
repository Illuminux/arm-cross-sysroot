#!/bin/bash

GV_url="http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.9.91.tar.bz2"
GV_sha1="9f4dff0a6e50ade2b919f33795eae8438a285595"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--enable-libxml2"
		"--disable-docs"
		"--with-arch=ARM"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install
	
fi
