#!/bin/bash

GV_url="http://libssh2.org/download/libssh2-1.4.2.tar.gz"

DEPEND=(
	"openssl"
)

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

FU_tools_get_names_from_url
FU_tools_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -ldl"
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build
	
	unset LIBS
	export LIBS=$TMP_LIBS
fi
