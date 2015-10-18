#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
##
## something is wrong cannot build jessie version
##
#if [ "${UV_dist}" == "jessie" ]; then
#	GV_url="http://libssh2.org/download/libssh2-1.4.3.tar.gz"
#	GV_sha1="c27ca83e1ffeeac03be98b6eef54448701e044b0"
#else
	GV_url="http://libssh2.org/download/libssh2-1.4.2.tar.gz"
	GV_sha1="7fc084254dabe14a9bc90fa3d569faa7ee943e19"
#fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libssh2.pc"

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
		"--enable-debug"
		"--disable-largefile"
		"--disable-examples-build"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
