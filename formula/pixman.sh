#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://xorg.freedesktop.org/releases/individual/lib/pixman-0.32.6.tar.bz2"
	GV_sha1="5b730399e1e212e5acaa69a4f1a2c7be1af1cdc4"
else
	GV_url="http://xorg.freedesktop.org/releases/individual/lib/pixman-0.26.0.tar.bz2"
	GV_sha1="d772cf794ec5da0966eba3cb360919a0a5e0d23f"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "pixman-1.pc"

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
		"--disable-mmx"
		"--disable-sse2"
		"--disable-vmx"
		"--disable-arm-iwmmxt"
		"--disable-mips-dspr2"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
