#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
GV_url="http://netix.dl.sourceforge.net/project/libvisual/libvisual/libvisual-0.4.0/libvisual-0.4.0.tar.gz"
GV_sha1="bd21d621f1d54134c26138e19eaae46c5aeaec00"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libvisual-0.4.pc"

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
		"--disable-nls"
		"--enable-debug"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libvisual-0.4"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
