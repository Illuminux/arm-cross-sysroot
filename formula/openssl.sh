#!/bin/bash

GV_url="http://www.openssl.org/source/openssl-1.0.1j.tar.gz"

GV_depend=(
	"zlib"
	"cryptodev"
)

FU_tools_get_names_from_url
FU_tools_installed "openssl.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	FU_file_get_download
	FU_file_extract_tar

	cd "${GV_source_dir}/${GV_dir_name}"

	export ARCH="arm"
	export CROSS_COMPILE="${GV_host}-"
	
	echo -n "Configure ${GV_name}... "
	if [ "$GV_conf_show" == true ]; then
		./Configure \
			linux-generic32 \
			--prefix="${UV_sysroot_dir}" \
			--openssldir="${UV_sysroot_dir}/${GV_host}/ssl" \
			zlib-dynamic \
			shared \
			no-sse2 \
			-DHAVE_CRYPTODEV 2>&1
	else
		./Configure \
			linux-generic32 \
			--prefix="${UV_sysroot_dir}" \
			--openssldir="${UV_sysroot_dir}/${GV_host}/ssl" \
			zlib-dynamic \
			shared \
			no-sse2 \
			-DHAVE_CRYPTODEV >$GV_log_file 2>&1
	fi
	FU_tools_is_error "$?"

	# Must be built with j1 otherwise it crashes!!!
	FU_build_make "-j1"
	FU_build_install "all install_sw"

	mv -f "${UV_sysroot_dir}/bin/openssl" \
		"${UV_sysroot_dir}/${GV_host}/bin/${GV_host}-openssl"
	mv -f "${UV_sysroot_dir}/bin/c_rehash" \
		"${UV_sysroot_dir}/${GV_host}/bin/${GV_host}-c_rehash"
	
	if ! [ "$(ls -A '${UV_sysroot_dir}/bin')" ]; then
		rm -rf "${UV_sysroot_dir}/bin"
	fi
	
	FU_build_finishinstall
	
	unset ARCH
	unset CROSS_COMPILE

fi
