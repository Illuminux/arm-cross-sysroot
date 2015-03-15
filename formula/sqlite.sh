#!/bin/bash

GV_url="http://sqlite.org/2014/sqlite-autoconf-3080700.tar.gz"

DEPEND=(
	"readline"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-largefile"
	"--enable-readline"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "sqlite3.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
