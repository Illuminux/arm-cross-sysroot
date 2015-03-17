#!/bin/bash

GV_url="http://xcb.freedesktop.org/dist/libxcb-1.8.1.tar.bz2"

DEPEND=(
	"libXau"
	"xcb-proto"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-build-docs"
	"--without-python"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "xcb.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build
fi
