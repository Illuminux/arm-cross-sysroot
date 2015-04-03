#!/bin/bash

GV_url="http://download.gna.org/cryptodev-linux/cryptodev-linux-1.6.tar.gz"
GV_sha1="2b7610c76fba52ef92352c8e1877299bec316516"

GV_depend=()

FU_tools_get_names_from_url

echo -n "Build $GV_name:"

if ! [ -d "${GV_prefix}/include/crypto" ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	echo
	
	FU_file_get_download
	FU_file_extract_tar
	
	echo -n "Install ${GV_name}... "
	do_mkdir "${GV_prefix}/include"
	do_cpdir "${GV_source_dir}/${GV_dir_name}/crypto" "${GV_prefix}/include/"
	FU_tools_is_error "$?"
	
	cd $GV_base_dir
	
	FU_build_finishinstall
else
	echo " already installed"
fi
