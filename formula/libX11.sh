#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/lib/libX11-1.5.0.tar.bz2"
GV_sha1="8177535c9c59d8c3ab98d55ce53520b5737ccd1a"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "x11.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-composecache"
		"--without-xmlto"
		"--without-fop"
		"--without-xsltproc"
		"--without-launchd"
		"--with-locale-lib-dir=${UV_sysroot_dir}/lib"
		"--without-util"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure	
	FU_build_make
	FU_build_install
	
fi
