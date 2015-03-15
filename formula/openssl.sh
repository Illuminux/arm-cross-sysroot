#!/bin/bash

GV_url="http://www.openssl.org/source/openssl-1.0.1j.tar.gz"

DEPEND=(
	"zlib"
	"cryptodev"
)

GV_args=()

FU_get_names_from_url
FU_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar

	cd "${GV_source_dir}/${GV_dir_name}"

	export ARCH="arm"
	export CROSS_COMPILE="${GV_host}-"

	echo -n "Configure ${GV_name}... "
	./Configure \
		linux-generic32 \
		--prefix=$GV_prefix \
		zlib-dynamic \
		shared \
		no-sse2 \
		-DHAVE_CRYPTODEV >$GV_log_file 2>&1
	FU_is_error "$?"

	# Must be built with j1 otherwise it crashes!!!
	FU_build_make "-j1"
	FU_build_install

	cd $GV_base_dir
	rm -rf "${UV_sysroot_dir}/ssl"
	
	FU_build_finishinstall
fi