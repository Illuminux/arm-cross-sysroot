#!/bin/bash

GV_url="http://zlib.net/zlib-1.2.8.tar.gz"

DEPEND=()

GV_args=()

FU_tools_get_names_from_url
FU_tools_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	export CGV_host=$UV_target
	FU_file_get_download
	FU_file_extract_tar
	FU_build
	unset CGV_host

	cd $GV_base_dir
	rm -rf "$UV_sysroot_dir/share"
fi
