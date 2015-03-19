#!/bin/bash

GV_url="https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz"

DEPEND=(
	"gmp"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_tools_get_names_from_url
GV_version="2.0.19-stable"
FU_tools_installed "libevent.pc"

if [ $? == 1 ]; then
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build
fi
