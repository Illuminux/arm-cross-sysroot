#!/bin/bash

GV_url="ftp://xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz"
GV_sha1="a0c553bd51ba79ab6fff26dc700004c6a41f5250"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libxml-2.0.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-llzma -lrt -lpthread"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--without-python"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libxml2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
