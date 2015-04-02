#!/bin/bash

GV_url="http://curl.haxx.se/download/curl-7.26.0.tar.bz2"
GV_sha1="c2e62eaace2407d377bf544d1f808aea6dddf64c"

GV_depend=(
	"zlib"
	"cryptodev"
	"openssl"
	"libgpg-error"
	"libgcrypt"
	"libssh"
)

FU_tools_get_names_from_url
FU_tools_installed "libcurl.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lpthread -ldl"

	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--with-ssl"
		"--enable-ipv6"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	unset LIBS
fi
