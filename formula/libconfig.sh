#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://www.hyperrealm.com/libconfig/libconfig-1.4.9.tar.gz"
	GV_sha1="b7a3c307dfb388e57d9a35c7f13f6232116930ec"
else
	GV_url="http://www.hyperrealm.com/libconfig/libconfig-1.4.8.tar.gz"
	GV_sha1="c16b9caa207afdf36fc664ad0b2807ecc7a562fa"
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
	)

	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
