#!/bin/bash

GV_url="https://libav.org/releases/libav-0.8.16.tar.xz"

DEPEND=()

GV_args=(
	"--cross-prefix=${GV_host}-"
	"--target-os=linux"
	"--arch=arm"
	"--enable-cross-compile"
	"--enable-shared"
	"--disable-static"
	"--datadir=${GV_base_dir}/tmp/share/avconv"
	"--mandir=${GV_base_dir}/tmp/share/man"
	"--disable-altivec"
	"--disable-amd3dnow"
	"--disable-amd3dnowext"
	"--disable-mmx"
	"--disable-mmx2"
	"--disable-sse"
	"--disable-ssse3"
	"--disable-avx"
	"--enable-gpl"
)

if [ $GV_build_os = "Darwin" ]; then 
	GV_args+=(
		"--ar=gar"
	)
fi


if [ "${UV_board}" == "beaglebone" ]; then 
	GV_args+=("--cpu=cortex-a8")
elif [ "${UV_board}" == "raspi" ]; then
	GV_args+=("--disable-neon")
else
	GV_args+=("--disable-neon")
fi

get_names_from_url
installed "libavutil.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi