#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/util/util-macros-1.16.2.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${UV_sysroot_dir}/lib"
)

FU_tools_get_names_from_url
FU_tools_installed "xorg-macros.pc"

if [ $? == 1 ]; then
	FU_file_get_download
	FU_file_extract_tar
	FU_build
fi
