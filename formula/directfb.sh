#!/bin/bash

GV_url="http://directfb.org/downloads/Core/DirectFB-1.2/DirectFB-1.2.10.tar.gz"

DEPEND=(
	"freetype"
	"libjpeg"
	"libpng"
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
	"--enable-zlibu"
	"--disable-voodoo"
	"--disable-mmx"
	"--disable-sse"
	"--disable-png"
)

FU_get_names_from_url
FU_installed "directfb.pc"

if [ $? == 1 ]; then
	
	TMP_LDFLAGS=$LDFLAGS
	export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/lib/ts"
	
	FU_get_download
	FU_extract_tar
	
	echo -n "Patch ${GV_name}... "
	patch "${GV_source_dir}/${GV_dir_name}/gfxdrivers/davinci/davinci_c64x.c" \
		< "${GV_base_dir}/patches/directfb_davinci.patch" >$GV_log_file 2>&1
	FU_is_error "$?"
	
	FU_build
	
	unset LDFLAGS
	export LDFLAGS=$TMP_LDFLAGS
fi
