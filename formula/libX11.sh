#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://xorg.freedesktop.org/releases/individual/lib/libX11-1.6.2.tar.bz2"
	GV_sha1="0dd74854e6f6bb8a322e88ba3e89f87c3dcf9e08"
else
	GV_url="http://xorg.freedesktop.org/releases/individual/lib/libX11-1.5.0.tar.bz2"
	GV_sha1="8177535c9c59d8c3ab98d55ce53520b5737ccd1a"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "x11.pc"

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
		"--disable-composecache"
		"--without-xmlto"
		"--without-fop"
		"--without-xsltproc"
		"--without-launchd"
		"--with-locale-lib-dir=${UV_sysroot_dir}/lib"
		"--without-util"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure	
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
