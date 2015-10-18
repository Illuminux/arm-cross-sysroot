#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz"
	GV_sha1="3e6674772eb77de24908c6267c698146420ab699"
else
	GV_url="https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz"
	GV_sha1="28c109190345ce5469add8cf3f45c5dd57fe2a85"
fi

GV_depend=()

FU_tools_get_names_from_url
if [ "${UV_dist}" == "jessie" ]; then
	GV_version="2.0.21-stable"
else
	GV_version="2.0.19-stable"
fi
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
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
