#!/bin/bash

GV_url="http://code.entropywave.com/download/orc/orc-0.4.16.tar.gz"

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
	"--datadir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "orc-0.4.pc"

if [ $? == 1 ]; then
	
	get_download
	extract_tar
	build
	
fi