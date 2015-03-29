#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/proto/xextproto-7.2.1.tar.bz2"

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
		"--without-xmlto"
		"--without-fop"
		"--without-xsltproc"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
fi
