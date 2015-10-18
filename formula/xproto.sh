#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.26.tar.bz2"
	GV_sha1="81101b78052fa0f652982081f9328f912b71a948"
else
	GV_url="http://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.23.tar.bz2"
	GV_sha1="5d7f00d1dbe6cf8e725841ef663f0ee2491ba5b2"
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
		"--enable-shared"
		"--disable-static"
		"--disable-docs"
		"--without-xmlto"
		"--without-fop"
		"--without-xsltproc"
		"--without-xmlto"
		"--without-fop"
		"--without-xsltproc"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
