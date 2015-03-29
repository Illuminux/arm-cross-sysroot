#!/bin/bash

GV_url="http://sourceforge.net/projects/tslib.berlios/files/tslib-1.0.tar.bz2"

GV_depend=()

FU_tools_get_names_from_url
GV_version="0.0.2"
FU_tools_installed "tslib-0.0.pc"

if [ $? == 1 ]; then

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--enable-debug"
		"ac_cv_func_malloc_0_nonnull=yes"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_autogen
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
	$LIBTOOL --finish "${UV_sysroot_dir}/lib/ts/"
	
fi
