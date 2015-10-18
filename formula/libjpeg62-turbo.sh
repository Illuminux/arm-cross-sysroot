#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
GV_url="http://netix.dl.sourceforge.net/project/libjpeg-turbo/1.3.1/libjpeg-turbo-1.3.1.tar.gz"
GV_sha1="5fa19252e5ca992cfa40446a0210ceff55fbe468"

GV_depend=()

FU_tools_get_names_from_url
#GV_version="8d1"
FU_tools_installed "libjpeg.pc"

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
		"--with-jpeg7"
		"--with-jpeg8"
	)
	
	FU_file_get_download
	FU_file_extract_tar

#	GV_dir_name="jpeg-8d1"
#	GV_name=${GV_dir_name%-*}
#	GV_version=${GV_dir_name##$GV_name*-}
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
	PKG_libs="-ljpeg"
	
	GV_name="libjpeg"
	FU_build_pkg_file 
	FU_build_finishinstall
fi
