#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://www.openssl.org/source/openssl-1.0.1k.tar.gz"
	GV_sha1="19d818e202558c212a9583fcdaf876995a633ddf"
else
	GV_url="http://www.openssl.org/source/openssl-1.0.1e.tar.gz"
	GV_sha1="3f1b1223c9e8189bfe4e186d86449775bd903460"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "openssl.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"linux-generic32"
		"--prefix=${UV_sysroot_dir}"
		"--openssldir=${GV_prefix}/ssl"
		"zlib-dynamic"
		"shared"
		"no-sse2"
		"-DHAVE_CRYPTODEV"
	)
	
	FU_file_get_download
	FU_file_extract_tar

	cd "${GV_source_dir}/${GV_dir_name}"

	export ARCH="arm"
	export CROSS_COMPILE="${GV_host}-"
	
	echo -n "Configure ${GV_name}... "
	if [ "$GV_debug" == true ]; then
		./Configure ${GV_args[*]} 2>&1
	else
		./Configure ${GV_args[*]} >$GV_log_file 2>&1
	fi
	FU_tools_is_error "configure"

	# Must be built with j1 otherwise it crashes!!!
	FU_build_make "-j1"
	FU_build_install "install_sw"
	
	do_mkdir "${GV_prefix}/bin"

	mv -f "${UV_sysroot_dir}/bin/openssl" \
		"${GV_prefix}/bin/${GV_host}-openssl"
	mv -f "${UV_sysroot_dir}/bin/c_rehash" \
		"${GV_prefix}/bin/${GV_host}-c_rehash"
	
	if ! [ "$(ls -A ${UV_sysroot_dir}/bin)" ]; then
		rm -rf "${UV_sysroot_dir}/bin"
	fi
	
	FU_build_finishinstall
	
	unset ARCH
	unset CROSS_COMPILE
	
fi
