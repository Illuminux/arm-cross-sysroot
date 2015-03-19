#!/bin/bash

GV_url="http://tukaani.org/xz/xz-5.1.4beta.tar.gz"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-nls"
	"--disable-doc"
	"--disable-scripts"
	"--disable-lzma-links"
	"--disable-lzmainfo"
	"--disable-lzmadec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_tools_get_names_from_url
FU_tools_installed "liblzma.pc"

if [ $? == 1 ]; then
	FU_file_get_download
	FU_file_extract_tar
	FU_build
fi