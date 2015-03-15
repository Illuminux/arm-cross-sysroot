#!/bin/bash

GV_url="http://curl.haxx.se/download/curl-7.26.0.tar.bz2"

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
	"--with-ssl"
	"--enable-ipv6"
)

FU_get_names_from_url
FU_installed "libcurl.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -ldl"
	
	FU_get_download
	FU_extract_tar
	FU_build
	
	unset LIBS
	export LIBS=$TMP_LIBS
fi
