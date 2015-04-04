#!/bin/bash

GV_url="http://download.sourceforge.net/libpng/libpng-1.6.16.tar.xz"
GV_sha1="31855a8438ae795d249574b0da15b34eb0922e13"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libpng16.pc"

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
	
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libpng16"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
