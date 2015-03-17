#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/proto/videoproto-2.3.2.tar.bz2"

DEPEND=(
	"util-macros"
	"xextproto"
)

GV_args=(
	"--host=${GV_host}"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "videoproto.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build
fi
