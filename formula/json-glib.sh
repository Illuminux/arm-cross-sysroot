#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="ftp://ftp.gnome.org/pub/gnome/sources/json-glib//1.0/json-glib-1.0.0.tar.xz"
	GV_sha1="ed48f3d276327ba4ce22fb42494d95141e37893f"
else
	GV_url="ftp://ftp.gnome.org/pub/gnome/sources/json-glib/0.14/json-glib-0.14.2.tar.xz"
	GV_sha1="077c5a7bfabdaefba1f4472100e29add9aa910a4"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "json-glib-1.0.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--disable-glibtest"
		"--disable-gtk-doc"
		"--disable-nls"
	)

	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
