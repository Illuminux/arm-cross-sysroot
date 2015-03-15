#!/bin/bash

GV_url="http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.gz"

DEPEND=()

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

get_names_from_url
installed "ogg.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
