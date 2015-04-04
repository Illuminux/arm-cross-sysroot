#!/bin/bash

GV_url="http://mirror.checkdomain.de/imagemagick/releases/ImageMagick-6.7.7-10.tar.bz2"
GV_sha1="acb4f2647a19895abb2af5bd1379b0cca151c58a"

GV_depend=()

FU_tools_get_names_from_url
GV_version="6.7.7"
FU_tools_installed "ImageMagick.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
#	export LIBS="-lpthread -lpng16 -ltiff -lxml2 -lz -lm -ljpeg -llzma -ldl -llcms2"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-openmp"
		"--disable-opencl"
		"--disable-largefile"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	unset LIBS

fi
