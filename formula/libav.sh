#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="https://libav.org/releases/libav-11.4.tar.xz"
	GV_sha1="c2ab12102de187f2675a56b828b4a5e9136ab747"
else
	GV_url="https://libav.org/releases/libav-0.8.16.tar.xz"
	GV_sha1="df88b8f7d04d47edea8b19d80814227f0c058e57"
fi

GV_depend=()

FU_tools_get_names_from_url
if [ "${UV_dist}" == "jessie" ]; then
	GV_version="54.3.0"
else
	GV_version="51.22.2"
fi
FU_tools_installed "libavutil.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	TMP_LDFLAGS=$LDFLAGS	
	export LDFLAGS="${LDFLAGS} -lcairo -lpixman-1 -lfontconfig -lxml2 -llzma -ldirectfb -lfusion -ldirect -lpng -lxcb-shm -lX11-xcb -lxcb-render -lX11 -lxcb -lXau -ldl -lfreetype -lpthread -lmp3lame -lz -lm -lrt"

	GV_args=(
		"--prefix=${GV_prefix}" 
		"--cross-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--shlibdir=${UV_sysroot_dir}/lib"
		"--incdir=${UV_sysroot_dir}/include"
		"--target-os=linux"
		"--arch=arm"
		"--enable-cross-compile"
		"--enable-shared"
		"--disable-static"
		"--disable-altivec"
		"--disable-amd3dnow"
		"--disable-amd3dnowext"
		"--disable-mmx"
		"--disable-sse"
		"--disable-ssse3"
		"--disable-avx"
		"--enable-gpl"
		"--enable-libfreetype"
		"--enable-libtheora"
		"--enable-libvorbis"
		"--enable-libx264"
		"--enable-nonfree"
		"--enable-openssl"
		"--enable-libmp3lame"
	)
	
	if [ "${UV_dist}" == "wheezy" ]; then
		GV_args+=(
			"--disable-mmx2"
		)
	fi
	
	if [ $GV_build_os = "Darwin" ]; then 
		GV_args+=(
			"--ar=gar"
		)
	fi
	
	if [ "${UV_board}" == "beaglebone" ]; then 
		GV_args+=("--cpu=cortex-a8")
		GV_args+=("--enable-neon")
	elif [ "${UV_board}" == "raspi" ]; then
		GV_args+=("--disable-neon")
	else
		GV_args+=("--disable-neon")
	fi
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
	
	export LDFLAGS=$TMP_LDFLAGS
fi