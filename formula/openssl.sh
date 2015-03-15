#!/bin/bash

GV_url="http://www.openssl.org/source/openssl-1.0.1j.tar.gz"

DEPEND=(
	"zlib"
	"cryptodev"
)

GV_args=()

get_names_from_url
installed "${GV_name}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar

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
	is_error "$?"

	# Must be built with j1 otherwise it crashes!!!
	build_make "-j1"
	build_install

	cd $GV_base_dir
	rm -rf "${UV_sysroot_dir}/ssl"
	
	build_finishinstall
fi