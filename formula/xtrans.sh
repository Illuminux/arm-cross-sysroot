#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://xorg.freedesktop.org/releases/individual/lib/xtrans-1.3.4.tar.bz2"
	GV_sha1="beb2cecc4ceb8fab0557a8c37e2d41e63cbaa5ed"
else
	GV_url="http://xorg.freedesktop.org/releases/individual/lib/xtrans-1.2.7.tar.bz2"
	GV_sha1="b6ed421edf577816f6e641e1846dc0bff337676c"
fi

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
		"--disable-docs"
		"--without-xmlto"
		"--without-fop"
		"--without-xsltproc"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install
	
	mv -f "${GV_prefix}/share/pkgconfig/xtrans.pc" \
		"${UV_sysroot_dir}/lib/pkgconfig/"

	FU_build_finishinstall
fi
