#!/bin/bash

GV_url="http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.40/libsoup-2.40.3.tar.xz"

GV_depend=(
	"glib"
	"libxml2"
	"sqlite"
)

FU_tools_get_names_from_url
FU_tools_installed "libsoup-2.4.pc"

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
		"--disable-tls-check"
		"--without-gnome"
	)

	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
fi
