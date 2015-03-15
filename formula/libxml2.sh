#!/bin/bash

GV_url="ftp://xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz"

DEPEND=(
	"zlib"
	"liblzma"
)


## @TODO Error while compiling with liblzma

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--without-python"
	"--without-lzma"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url

LIBSML2SCR=$GV_dir_name

FU_installed "libxml-2.0.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libxml2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
