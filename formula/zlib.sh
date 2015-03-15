#!/bin/bash

GV_url="http://zlib.net/zlib-1.2.8.tar.gz"

GV_args=()

get_names_from_url
installed "${GV_name}.pc"

if [ $? == 1 ]; then
	export CGV_host=$UV_target
	get_download
	extract_tar
	build
	unset CGV_host

	cd $GV_base_dir
	rm -rf "$UV_sysroot_dir/share"
fi
