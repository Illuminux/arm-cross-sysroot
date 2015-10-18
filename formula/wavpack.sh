#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://www.wavpack.com/wavpack-4.70.0.tar.bz2"
	GV_sha1="7bf2022c988c19067196ee1fdadc919baacf46d1"
else
	GV_url="http://www.wavpack.com/wavpack-4.60.1.tar.bz2"
	GV_sha1="003c65cb4e29c55011cf8e7b10d69120df5e7f30"
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
		"--disable-largefile"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	cp -rf "${GV_prefix}/include/wavpack" \
		"${UV_sysroot_dir}/include/"

	FU_build_finishinstall
fi
