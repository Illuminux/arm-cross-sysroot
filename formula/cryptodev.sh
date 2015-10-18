#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
GV_url="http://download.gna.org/cryptodev-linux/cryptodev-linux-1.6.tar.gz"
GV_sha1="2b7610c76fba52ef92352c8e1877299bec316516"

GV_depend=()

FU_tools_get_names_from_url

echo -n "Build $GV_name:"

if ! [ -d "${UV_sysroot_dir}/include/crypto" ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	echo
	
	FU_file_get_download
	FU_file_extract_tar
	
	echo -n "Install ${GV_name}... "
	do_mkdir "${UV_sysroot_dir}/include"
	do_cpdir "${GV_source_dir}/${GV_dir_name}/crypto" "${UV_sysroot_dir}/include/"
	FU_tools_is_error "install"
	
	cd $GV_base_dir
	
	FU_build_finishinstall
else
	echo " already installed"
fi
