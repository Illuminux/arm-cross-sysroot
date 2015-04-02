#!/bin/bash

GV_url="ftp://ftp.gnome.org/pub/gnome/sources/json-glib//0.14/json-glib-0.14.2.tar.xz"
GV_sha1="077c5a7bfabdaefba1f4472100e29add9aa910a4"

GV_depend=(
	"zlib"
	"libffi"
	"glib"
)

FU_tools_get_names_from_url
FU_tools_installed "json-glib-1.0.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
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
	
fi
