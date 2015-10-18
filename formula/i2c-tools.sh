#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://dev.gateworks.com/sources/i2c-tools-3.1.1.tar.bz2"
	GV_sha1="05e4e3b34ebc921812e14527936c0fae65729204"
else
	GV_url="http://dev.gateworks.com/sources/i2c-tools-3.1.0.tar.bz2"
	GV_sha1="0756c9cffb7865d9815d44727de86973a28aba23"
fi

GV_depend=()

FU_tools_get_names_from_url

echo -n "Build $GV_name:"

if ! [ -f "${UV_sysroot_dir}/include/linux/i2c-dev.h" ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	echo
		
	FU_file_get_download
	FU_file_extract_tar
	
	echo -n "Install ${GV_name}... "
	do_mkdir "${UV_sysroot_dir}/include/linux"
	do_cpdir "${GV_source_dir}/${GV_dir_name}/include/linux" "${UV_sysroot_dir}/include/"		
	FU_tools_is_error "install"
	
	cd $GV_base_dir
	
	FU_build_finishinstall
else
	echo " already installed"
fi
