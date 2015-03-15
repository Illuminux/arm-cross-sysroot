#!/bin/bash

GV_url="http://switch.dl.sourceforge.net/project/libvisual/libvisual/libvisual-0.4.0/libvisual-0.4.0.tar.gz"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--disable-nls"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datadir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "libvisual-0.4.pc"

if [ $? == 1 ]; then
	
	FU_get_download
	FU_extract_tar
	FU_build
	
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libvisual-0.4"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
