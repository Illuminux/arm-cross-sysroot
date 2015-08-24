#!/bin/bash

GV_url="http://sources.buildroot.net/DirectFB-1.4.1.tar.gz"
GV_sha1="98f3c46789fa599367037654ee35b71f453b68b3"

GV_depend=(
	"zlib"
	"tslib"
	"freetype"
	"libpng"
	"jpeg"
	"libX11"
	"libXext"
	"xproto"
	"xextproto"
	"inputproto"
	"xcb-proto"
	"videoproto"
	"kbproto"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--enable-zlib"
		"--disable-png"
		"--enable-debug"
		"--disable-voodoo"
		"--disable-mmx"
		"--disable-sse"
		"--enable-freetype"
		"--with-gfxdrivers=davinci,neomagic,nsc,omap,vmware"
		"--with-inputdrivers=dynapro,elo-input,gunze,h3600_ts,joystick,keyboard,linuxinput,lirc,mutouch,penmount,ps2mouse,serialmouse,sonypijogdial,tslib,ucb1x00,wm97xx"
		"--with-sysroot=${UV_sysroot_dir}"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	echo -n "Patch ${GV_name}... "
	patch "${GV_source_dir}/${GV_dir_name}/gfxdrivers/davinci/davinci_c64x.c" \
		< "${GV_base_dir}/patches/directfb_davinci.patch" >$GV_log_file 2>&1
	FU_tools_is_error "patch"
	
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
fi

export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/lib/directfb-1.2-9"
