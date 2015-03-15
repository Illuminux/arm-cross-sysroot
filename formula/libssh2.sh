#!/bin/bash

GV_url="http://libssh2.org/download/libssh2-1.4.2.tar.gz"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--sbindir==${GV_base_dir}/tmp/sbin"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
)

get_names_from_url
installed "${GV_name}.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -ldl"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS
fi
