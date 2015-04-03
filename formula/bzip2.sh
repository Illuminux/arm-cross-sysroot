#!/bin/bash

GV_url="http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
GV_sha1="3f89f861209ce81a6bab1fd1998c0ef311712002"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"
if [ $? == 1 ]; then
	
	FU_tools_check_depend
		
	FU_file_get_download
	FU_file_extract_tar
	
	GV_args=(
		"-f"
		"Makefile-libbz2_so"
		"CC=${UV_target}-gcc"
		"AR=${UV_target}-ar"
		"RANLIB=${UV_target}-ranlib"
		"PREFIX=${UV_sysroot_dir}/${GV_host}"
	)
	
	FU_build_make ${GV_args[*]}
	
	GV_args=(
		"install"
		"CC=${UV_target}-gcc"
		"AR=${UV_target}-ar"
		"RANLIB=${UV_target}-ranlib"
		"PREFIX=${UV_sysroot_dir}/${GV_host}"
	)
	
	FU_build_install ${GV_args[*]}
	
	do_cd "${GV_source_dir}/${GV_dir_name}"
	cp -av libbz2.so* "${UV_sysroot_dir}/lib" >/dev/null
	
	do_cd "${UV_sysroot_dir}/${GV_host}/lib"
	mv -f libbz2.* "${UV_sysroot_dir}/lib" >/dev/null
	
	do_cd "${UV_sysroot_dir}/${GV_host}/include"
	mv -f bzlib.* "${UV_sysroot_dir}/include" >/dev/null
	
	do_cd $GV_base_dir
	rmdir "${UV_sysroot_dir}/${GV_host}/lib" #>/dev/null
	rmdir "${UV_sysroot_dir}/${GV_host}/include" #>/dev/null

	FU_build_pkg_file "-lbzip2"
	
	FU_build_finishinstall 

fi
