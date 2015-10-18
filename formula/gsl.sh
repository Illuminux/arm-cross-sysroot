#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="ftp://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz"
	GV_sha1="210af9366485f149140973700d90dc93a4b6213e"	
else
	GV_url="ftp://ftp.gnu.org/gnu/gsl/gsl-1.15.tar.gz"
	GV_sha1="d914f84b39a5274b0a589d9b83a66f44cd17ca8e"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export LIBS="-lm"

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
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
