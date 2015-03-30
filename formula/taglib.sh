#!/bin/bash

GV_url="http://ktown.kde.org/~wheeler/files/src/taglib-1.7.2.tar.gz"
GV_sha1="e657384ccf3284db2daba32dccece74534286012"

GV_depend=(
	"zlib"
)

FU_tools_get_names_from_url
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
		"-DCMAKE_LIBRARY_PATH='${UV_sysroot_dir}/lib'"
		"-DCMAKE_INCLUDE_PATH='${UV_sysroot_dir}/include'"
		"-DZLIB_INCLUDE_DIR='${UV_sysroot_dir}/include'"
		"-DZLIB_LIBRARY='${UV_sysroot_dir}/lib/libz.so'"
		"-DCMAKE_RELEASE_TYPE='Release'"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Configure ${GV_name}... "
	cmake ${GV_args[@]}	>$GV_log_file 2>&1
	FU_tools_is_error "$?"
	
	FU_build_make
	FU_build_install
	
	unset CC
	unset CXX
	unset AR
	unset RANLIB
fi
