#!/bin/bash

URL="http://zlib.net/zlib-1.2.8.tar.gz"

ARGS=()

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	export CHOST=$TARGET
	get_download
	extract_tar
	build
	unset CHOST

	cd $BASE_DIR
	rm -rf "$SYSROOT_DIR/share"
fi
