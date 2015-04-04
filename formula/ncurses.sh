#!/bin/bash

GV_url="http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz"
GV_sha1="3e042e5f2c7223bffdaac9646a533b8c758b65b5"

GV_depend=()


FU_tools_get_names_from_url
GV_version="5.9.20110404"
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
		"--with-shared"
		"--with-normal"
		"--with-debug"
		"--enable-pc-files"
		"--enable-ext-mouse"
		"--disable-big-core"
		"--disable-big-strings"
		"--disable-largefile"
		"--without-manpages"
		"--without-progs"
		"--without-tests"
		"ac_cv_path_PKG_CONFIG=${PKG_CONFIG_PATH}"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install

fi