#!/bin/bash

URL="ftp://ftp.videolan.org/pub/x264/snapshots/x264-snapshot-20141114-2245-stable.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--cross-prefix=${HOST}-"
	"--enable-shared"
)

get_names_from_url
installed "x264.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi