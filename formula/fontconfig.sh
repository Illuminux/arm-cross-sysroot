#!/bin/bash

GV_url="http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.9.91.tar.bz2"

DEPEND=(
	"zlib"
	"freetype"
	"expat"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--enable-libxml2"
	"--disable-docs"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_tools_get_names_from_url
FU_tools_installed "fontconfig.pc"

if [ $? == 1 ]; then
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build
	
fi