#!/bin/bash

GV_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.4.9.tar.bz2"

DEPEND=(
	"zlib"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--without-bzip2"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "freetype2.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/freetype2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
