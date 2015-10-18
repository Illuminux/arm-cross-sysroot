#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2"
	GV_sha1="c9c9361781911a47b28f74fc6ebe0abd1273fae4"
else
	GV_url="http://xcb.freedesktop.org/dist/xcb-util-image-0.3.9.tar.bz2"
	GV_sha1="afeba6230400fe8bec6076fd07bf20a8e412bbb5"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "xcb-image.pc"

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