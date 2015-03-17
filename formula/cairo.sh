#!/bin/bash

GV_url="http://cairographics.org/releases/cairo-1.12.2.tar.xz"

DEPEND=(
	"libpng"
	"glib"
	"pixman"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--enable-xml"
	"--enable-xlib-xcb"
	"--enable-directfb"
	"--program-prefix=${UV_target}-"
	"--disable-largefile"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	
#	cd "${GV_source_dir}/${GV_dir_name}"
#	echo -n "Patch ${GV_name}... "		
#	patch -p1 < "${GV_base_dir}/patches/cairo.patch" >$GV_log_file 2>&1
#	FU_is_error "$?"
#	cd $GV_base_dir
	
	FU_build
fi
