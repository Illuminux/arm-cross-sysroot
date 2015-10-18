#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2"
	GV_sha1="69639f7dc56a084f59a3198f3a8d72e4a73ff927"
else
	GV_url="http://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.1.tar.bz2"
	GV_sha1="42b30b157b0c47690baa847847e24c7c94412b75"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "lqr-1.pc"

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
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
