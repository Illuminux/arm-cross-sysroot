#!/bin/bash

if ! [ "${UV_board}" == "beaglebone" ]; then
	return
fi

GV_url="https://github.com/gumulka/BlackLib.git"
GV_sha1=""

GV_depend=()

GV_args=()

FU_tools_get_names_from_url
GV_version="2.0"
FU_tools_installed "BlackLib.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	export CC=$UV_target-gcc
	export CXX=$UV_target-g++

	GV_depend=()
		
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	
	FU_file_git_clone
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	patch -p1 < "${GV_base_dir}/patches/blacklib.patch" >$GV_log_file 2>&1
	
	GV_dir_name="${GV_dir_name}/v2_0"
	FU_build_make
	FU_build_install "install DESTDIR=$UV_sysroot_dir"
	
	cd $GV_base_dir
	
	unset CC
	unset CXX
	
	PKG_libs="-lblacklib"
	PKG_includedir="/BlackLib"
	
	FU_build_pkg_file 
	FU_build_finishinstall
fi