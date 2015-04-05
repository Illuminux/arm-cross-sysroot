#!/bin/bash

GV_url="http://switch.dl.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"
GV_sha1="03a0bfa85713adcc6b3383c12e2cc68a9cfbf4c4"

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
		"--disable-gtktest"
		"--disable-frontend"
	)

	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_pkg_file "-lmp3lame"
	FU_build_finishinstall
fi
