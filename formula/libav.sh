#!/bin/bash

URL="https://libav.org/releases/libav-0.8.16.tar.xz"

DEPEND=()

ARGS=(
	"--cross-prefix=${HOST}-"
	"--target-os=linux"
	"--arch=arm"
	"--enable-cross-compile"
	"--enable-shared"
	"--disable-static"
	"--datadir=${BASE_DIR}/tmp/share/avconv"
	"--mandir=${BASE_DIR}/tmp/share/man"
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

if [ $(uname -s) = "Darwin" ]; then 
	ARGS+=(
		"--ar=gar"
	)
fi


if [ "${BOARD}" == "beaglebone" ]; then 
	ARGS+=("--cpu=cortex-a8")
elif [ "${BOARD}" == "raspi" ]; then
	ARGS+=("--disable-neon")
else
	ARGS+=("--disable-neon")
fi

get_names_from_url
installed "libavutil.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi