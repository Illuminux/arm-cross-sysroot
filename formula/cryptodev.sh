#!/bin/bash

GV_url="http://download.gna.org/cryptodev-linux/cryptodev-linux-1.6.tar.gz"

DEPEND=()

GV_args=()

FU_tools_get_names_from_url

echo -n "Build $GV_name:"

if ! [ -d "${GV_prefix}/include/crypto" ]; then
	
	echo
	
	FU_file_get_download
	FU_file_extract_tar
	
	echo -n "Install ${GV_name}... "
	cp -r "${GV_source_dir}/${GV_dir_name}/crypto" "${GV_prefix}/include/"
	FU_tools_is_error "$?"
	
	cd $GV_base_dir
	
	FU_FU_build_finishinstall
else
	echo " already installed"
fi
