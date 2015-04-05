#!/bin/bash

GV_url="http://xcb.freedesktop.org/dist/libxcb-1.8.1.tar.bz2"
GV_sha1="98199b6054750a06cddd4e77baa4354af547ce6f"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xcb.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--enable-xinput"
		"--enable-xkb"
		"--disable-static"
		"--disable-build-docs"
		"--without-python"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
