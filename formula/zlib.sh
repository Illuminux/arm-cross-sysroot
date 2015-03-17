#!/bin/bash

GV_url="http://zlib.net/zlib-1.2.8.tar.gz"

DEPEND=()

GV_args=()

FU_get_names_from_url
FU_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	export CGV_host=$UV_target
	FU_get_download
	FU_extract_tar
	FU_build
	unset CGV_host

	cd $GV_base_dir
	rm -rf "$UV_sysroot_dir/share"
fi
