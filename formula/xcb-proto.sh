#!/bin/bash

GV_url="http://xcb.freedesktop.org/dist/xcb-proto-1.7.1.tar.gz"
GV_sha1="4c7d56da2669943b981eb5e739e5c89787140720"

GV_depend=(
	"util-macros"
	"xproto"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=( 
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
fi
