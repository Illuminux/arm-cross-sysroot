#!/bin/bash

GV_url="http://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.bz2"
GV_sha1="46d5a11a59a4e31f74f73dd70c5d57a59de2d0b4"

GV_depend=()

FU_tools_get_names_from_url
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
		"--enable-gmp-internals"
		"--enable-assert"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	PKG_libs="-lmpfr"
	
	FU_build_pkg_file
	FU_build_finishinstall
fi
