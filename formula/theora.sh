#!/bin/bash

GV_url="http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz"

GV_depend=(
	"ogg"
	"vorbis"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-logg -lvorbis -lm"

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-examples"
		"--disable-oggtest"
		"--disable-vorbistest"
		"--disable-sdltes"
		"--enable-telemetry"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	
	unset LIBS
	
fi

