#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/lib/libX11-1.5.0.tar.bz2"

GV_depend=(
	"util-macros"
	"xtrans"
	"xproto"
	"xextproto"
	"inputproto"
	"xcb-proto"
	"libpthread-stubs"
	"libXau"
	"libxslt"
	"libxcb"
	"videoproto"
	"kbproto"
	"fontconfig"
)

FU_tools_get_names_from_url
FU_tools_installed "x11.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lcrypto -ldl"

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-composecache"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make
	FU_build_install
	
	unset LIBS
	
fi
