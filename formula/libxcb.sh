#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://xcb.freedesktop.org/dist/libxcb-1.10.tar.bz2"
	GV_sha1="bb1a3113eca5146e2a1cf6379c2e52c212a757e0"
else
	GV_url="http://xcb.freedesktop.org/dist/libxcb-1.8.1.tar.bz2"
	GV_sha1="98199b6054750a06cddd4e77baa4354af547ce6f"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xcb.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--enable-xinput"
		"--enable-xkb"
		"--disable-static"
		"--disable-build-docs"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi