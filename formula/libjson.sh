#!/bin/bash

GV_url="https://s3.amazonaws.com/json-c_releases/releases/json-c-0.10.tar.gz"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "json.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
