#!/bin/bash

GV_url="http://tukaani.org/xz/xz-5.1.4beta.tar.gz"
GV_sha1="e6562e8c704b49a0ded7333dfd0da876a5714cdf"

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
		"--disable-nls"
		"--disable-doc"
		"--disable-scripts"
		"--disable-lzma-links"
		"--disable-lzmainfo"
		"--disable-lzmadec"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
