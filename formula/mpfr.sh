#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.bz2"
	GV_sha1="46d5a11a59a4e31f74f73dd70c5d57a59de2d0b4"
else
	GV_url="http://www.mpfr.org/mpfr-3.1.0/mpfr-3.1.0.tar.bz2"
	GV_sha1="9ba6dfe62dad298f0570daf182db31660f7f016c"
fi

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
