#!/bin/bash

GV_url="https://github.com/libical/libical/releases/download/v1.0.1/libical-1.0.1.tar.gz"
GV_sha1="904b2c2b5c2b30f0a508f9d56eaf316dd42fc923"

GV_depend=()

FU_tools_get_names_from_url
GV_version="1.0"
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
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
	FU_build_make	
	FU_build_install
	FU_build_finishinstall
	
	unset CC
	unset CXX
	unset AR
	unset RANLIB
fi