#!/bin/bash

GV_url="ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng12/libpng-1.2.53.tar.gz"

DEPEND=(
	"zlib"
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

get_names_from_url
installed "${GV_name}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
	
	ln -s "${UV_sysroot_dir}/include/libpng12" "${UV_sysroot_dir}/include/libpng"
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libpng12"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
