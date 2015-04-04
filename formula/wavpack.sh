#!/bin/bash

GV_url="http://www.wavpack.com/wavpack-4.70.0.tar.bz2"
GV_sha1="7bf2022c988c19067196ee1fdadc919baacf46d1"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-largefile"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	cp -rf "${UV_sysroot_dir}/${GV_host}/include/wavpack" \
		"${UV_sysroot_dir}/include/"

fi
