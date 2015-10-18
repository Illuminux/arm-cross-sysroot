#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.0.tar.bz2"
	GV_sha1="969818b0326ac08241b11cbeaa4f203699f9b550"
else
	GV_url="http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.9.91.tar.bz2"
	GV_sha1="9f4dff0a6e50ade2b919f33795eae8438a285595"
fi

GV_depend=(
	"zlib"
	"expat"
	"freetype"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lm -lz -lpng"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--enable-libxml2"
		"--disable-docs"
		"--with-arch=ARM"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi
