#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.48/libsoup-2.48.0.tar.xz"
	GV_sha1="2cb87c88a88c8c8b3948e0cfcb25eeb89db56f08"
else
	GV_url="http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.38/libsoup-2.38.1.tar.xz"
	GV_sha1="8418440ff59917dee2e5618965cf8683b61258bf"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libsoup-2.4.pc"

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
		"--disable-tls-check"
		"--without-gnome"
	)

	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
