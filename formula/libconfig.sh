#!/bin/bash

GV_url="http://www.hyperrealm.com/libconfig/libconfig-1.4.9.tar.gz"
GV_sha1="b7a3c307dfb388e57d9a35c7f13f6232116930ec"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--bindir=${UV_sysroot_dir}/${GV_host}/bin"
	"--sbindir=${UV_sysroot_dir}/tmp"
	"--libexecdir=${UV_sysroot_dir}/tmp"
	"--datadir=${UV_sysroot_dir}/tmp"
	"--docdir=${UV_sysroot_dir}/tmp"
	"--sysconfdir=${UV_sysroot_dir}/tmp"
	"--sharedstatedir=${UV_sysroot_dir}/tmp"
	"--localstatedir=${UV_sysroot_dir}/tmp"
	"--infodir=${UV_sysroot_dir}/tmp"
	"--mandir=${UV_sysroot_dir}/tmp"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then

	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
fi
