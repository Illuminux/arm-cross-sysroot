#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://optimate.dl.sourceforge.net/project/lcms/lcms/2.6/lcms2-2.6.tar.gz"
	GV_sha1="b0ecee5cb8391338e6c281d1c11dcae2bc22a5d2"
else
	GV_url="http://optimate.dl.sourceforge.net/project/lcms/lcms/2.2/lcms2-2.2.tar.gz"
	GV_sha1="55ae4884a92c7fbd491c118aa3b356814b1014df"
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
