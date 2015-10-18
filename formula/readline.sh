#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="ftp.gnu.org:/pub/gnu/readline/readline-6.3.tar.gz"
	GV_sha1="017b92dc7fd4e636a2b5c9265a77ccc05798c9e1"
else
	GV_url="ftp.gnu.org:/pub/gnu/readline/readline-6.2.tar.gz"
	GV_sha1="a9761cd9c3da485eb354175fcc2fe35856bc43ac"
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
		"--with-curses"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	if [ "${UV_dist}" == "jessie" ]; then	
		
		# Go into source dir of the package 
		do_cd "${GV_source_dir}/${GV_dir_name}" 
		
		autoconf configure.ac > configure
		chmod +x configure
		
		# Go back to base dir
		do_cd $GV_base_dir
	fi
	
	FU_build_configure	
	FU_build_make
	FU_build_install
	
	PKG_libs="-lreadline"
	
	FU_build_pkg_file 
	FU_build_finishinstall
fi
