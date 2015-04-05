#!/bin/bash

GV_url="http://download.osgeo.org/libtiff/tiff-4.0.2.tar.gz"
GV_sha1="d84b7b33a6cfb3d15ca386c8c16b05047f8b5352"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libtiff-4.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lpthread -llzma"

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
	FU_build_finishinstall
fi
