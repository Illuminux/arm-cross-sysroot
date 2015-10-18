#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="https://github.com/libical/libical/releases/download/v1.0.1/libical-1.0.1.tar.gz"
	GV_sha1="904b2c2b5c2b30f0a508f9d56eaf316dd42fc923"
else
	GV_url="https://github.com/libical/libical/archive/v0.48.tar.gz"
	GV_sha1="86c284c1d4b6ec5457dbca803b7ca1fc7574fc12"
fi

GV_depend=()

FU_tools_get_names_from_url

if [ "${UV_dist}" == "jessie" ]; then
	GV_version="1.0"
else
	GV_dir_name="libical-0.48"
	GV_name=${GV_dir_name%-*}
	GV_version="0.48"
fi

FU_tools_installed "libical.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	if [ "${UV_dist}" == "jessie" ]; then
		
		export CC="${UV_target}-gcc" \
		export CXX="${UV_target}-g++" \
		export AR="${UV_target}-ar" \
		export RANLIB="${UV_target}-ranlib"

		GV_args=(
			"-DCMAKE_SYSTEM_NAME='Linux'"
			"-DCMAKE_SYSTEM_VERSION=1"
			"-DCMAKE_SYSTEM_PROCESSOR='arm'"
			"-DCMAKE_C_COMPILER='$UV_target-gcc'"
			"-DCMAKE_CXX_COMPILER='$UV_target-g++'"
			"-DCMAKE_CROSSCOMPILING=True"
			"-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
			"-DSHARED_ONLY=yes"
		)
	
		FU_file_get_download
		FU_file_extract_tar
	
		FU_build_configure_cmake	
	else
		
		GV_args=(
			"--host=${GV_host}"
			"--prefix=${GV_prefix}" 
			"--program-prefix=${UV_target}-"
			"--libdir=${UV_sysroot_dir}/lib"
			"--includedir=${UV_sysroot_dir}/include"
			"--enable-shared"
			"--disable-static"
			"--disable-docs"
			"--enable-cxx"
			"--disable-java"
			"--disable-python"
		)
	
		FU_file_get_download
		FU_file_extract_tar
		
		FU_build_configure
	fi

	FU_build_make	
	FU_build_install
	FU_build_finishinstall
	
	unset CC
	unset CXX
	unset AR
	unset RANLIB
fi