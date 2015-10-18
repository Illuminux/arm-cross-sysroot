#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://ftp.x.org/pub/individual/doc/xorg-sgml-doctools-1.11.tar.bz2"
	GV_sha1="56acde359072d7ffc6627ffde5e2c698eb415ddc"
else
	GV_url="http://ftp.x.org/pub/individual/doc/xorg-sgml-doctools-1.10.tar.bz2"
	GV_sha1="db6332b07de8d8e224f0766a567abdc4e3804d32"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xorg-sgml-doctools.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install
	
	mv ${GV_prefix}/share/pkgconfig/xorg-sgml-doctools.pc ${UV_sysroot_dir}/lib/pkgconfig/.
	
	FU_build_finishinstall
fi
