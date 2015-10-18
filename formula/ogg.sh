#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"
	GV_sha1="df7f3977bbeda67306bc2a427257dd7375319d7d"
else
	GV_url="http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.gz"
	GV_sha1="a900af21b6d7db1c7aa74eb0c39589ed9db991b8"
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
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
