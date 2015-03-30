#!/bin/bash

GV_url="https://libav.org/releases/libav-0.8.16.tar.xz"
GV_sha1="df88b8f7d04d47edea8b19d80814227f0c058e57"

GV_depend=()

FU_tools_get_names_from_url
GV_version="51.22.2"
FU_tools_installed "libavutil.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LDFLAGS="${LDFLAGS} -lpthread -lm -ldl -ltheora -lcairo -lpixman-1 -lpng16 -lfontconfig -lfreetype -ldirectfb -lfusion -ldirect -lxcb-shm -lX11-xcb -lxcb-render -lX11 -lxcb -lXau -lxml2 -llzma -lgcrypt -lgpg-error -lcrypto -lz -lvorbis -logg"
	
	GV_args=(
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
		"--disable-mmx2"
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
	)
	
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
	
	unset LIBS

fi