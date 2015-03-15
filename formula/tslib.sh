#!/bin/bash

GV_url="http://sourceforge.net/projects/tslib.berlios/files/tslib-1.0.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
	"ac_cv_func_malloc_0_nonnull=yes"
)

get_names_from_url
installed "tslib-0.0.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
