#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
GV_url="http://xcb.freedesktop.org/dist/xcb-util-0.3.8.tar.bz2"
GV_sha1="71093ad81feb21758a2446cf3297bebaf03af228"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xcb-util.pc"

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
		"--disable-devel-docs"
		"--without-doxygen"
	)
	
	FU_file_get_download
	FU_file_extract_tar	
	
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi