#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz"
	GV_sha1="4df177de629b2653db322bfb891afa3c0d1fa221"
else
	GV_url="ftp://xmlsoft.org/libxml2/libxslt-1.1.27.tar.gz"
	GV_sha1="f8072177f1ffe1b9bb8759a9e3e6349e1eac1f66"
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
		"--with-crypto"
		"--without-python"
		"--with-gnu-ld"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
