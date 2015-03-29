#!/bin/bash

GV_url="http://www.libraw.org/data/LibRaw-0.16.0.tar.gz"

GV_depend=(
	"zlib"
	"libzma"
	"jpeg"
	"jasper"
	"lcms2"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lpthread -llcms2 -ljpeg -llzma -lz -lm"

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--enable-lcms"
		"--enable-jpeg"
		"--enable-jasper"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
	unset LIBS
	
fi
