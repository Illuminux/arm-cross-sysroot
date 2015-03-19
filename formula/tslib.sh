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

FU_tools_get_names_from_url
GV_version="0.0.2"
LV_pkg_name="tslib-0.0.pc"
FU_tools_installed $LV_pkg_name

if [ $? == 1 ]; then
	FU_file_get_download
	FU_file_extract_tar
	FU_build
	
	ln -s \
		"${UV_sysroot_dir}/lib/pkgconfig/${LV_pkg_name}" \
		"${UV_sysroot_dir}/lib/pkgconfig/tslib.pc" \
fi
