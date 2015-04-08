#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/lib/libXext-1.3.1.tar.bz2"
GV_sha1="764ac472ae19a0faade193717a9e0938d3430aaa"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xext.pc"

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
		"--without-xmlto"
		"--without-fop"
		"--without-xsltproc"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
