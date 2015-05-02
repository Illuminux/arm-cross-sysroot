#!/bin/bash

GV_base_dir=$(pwd)

echo "sha1-List:" > "./sha1-List.txt"

source "${GV_base_dir}/config.cfg"
source "${GV_base_dir}/include/settings.cfg"

for entry in `ls $UV_download_dir`; do
	
	if [ -f "${UV_download_dir}/${entry}" ]; then
    	echo "Name: ${entry}" 
		echo $(openssl sha1 "${UV_download_dir}/${entry}" | awk '{print $2}')
		echo 
	else
		echo "Name: ${entry} (Dir)"
	fi
	
done