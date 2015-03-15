#!/bin/bash

GV_url="ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
)

FU_get_names_from_url
FU_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build
	
	ln -s "${UV_sysroot_dir}/lib/${GV_dir_name}/include/ffi.h"       "${UV_sysroot_dir}/include/"
	ln -s "${UV_sysroot_dir}/lib/${GV_dir_name}/include/ffitarget.h" "${UV_sysroot_dir}/include/"
fi
