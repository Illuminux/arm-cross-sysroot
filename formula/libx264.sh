#!/bin/bash

GV_url="ftp://ftp.videolan.org/pub/x264/snapshots/x264-snapshot-20141114-2245-stable.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--cross-prefix=${GV_host}-"
	"--enable-shared"
)

FU_get_names_from_url
FU_installed "x264.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build
fi