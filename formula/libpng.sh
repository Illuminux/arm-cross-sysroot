#!/bin/bash

GV_url="http://download.sourceforge.net/libpng/libpng-1.6.16.tar.xz"
GV_sha1="22f3cc22d26727af05d7c9a970a7d050b6761bd7"

GV_depend=(
	"zlib"
)

FU_tools_get_names_from_url
FU_tools_installed "libpng16.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
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
