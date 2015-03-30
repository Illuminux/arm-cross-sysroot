#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/proto/videoproto-2.3.2.tar.bz2"
GV_sha1="aa60e3b93c6a78ad03f1c502b910e7c45faaedbc"

GV_depend=(
	"util-macros"
	"xextproto"
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
