#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/lib/pixman-0.26.0.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-mmx"
	"--disable-sse2"
	"--disable-vmx"
	"--disable-arm-iwmmxt"
	"--disable-mips-dspr2"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "pixman-1.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
