#!/bin/bash

GV_url="https://github.com/flavio/qjson.git"
GV_sha1=""

GV_depend=(
	"qt"
)

FU_tools_get_names_from_url
GV_version="0.8.1"
FU_tools_installed "QJson.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	GV_build_start=`date +%s`
	
	GV_args=(
		"-DCMAKE_SYSTEM_NAME='Linux'"
		"-DCMAKE_SYSTEM_VERSION=1"
		"-DCMAKE_SYSTEM_PROCESSOR='arm'"
		"-DCMAKE_C_COMPILER='$UV_target-gcc'"
		"-DCMAKE_CXX_COMPILER='$UV_target-g++'"
		"-DCMAKE_FIND_ROOT_PATH='${CMAKE_FIND_ROOT_PATH} $UV_toolchain_dir'"
		"-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
		"-DQT_QMAKE_EXECUTABLE='${UV_sysroot_dir}/Qt/bin/qmake'"
		"${GV_source_dir}/${GV_dir_name}"
	)
	
	FU_file_git_clone
	
	# qjson has to be build in a seperate dir 
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	GV_dir_name="${GV_dir_name}/build"
	
	FU_build_configure_cmake
	FU_build_make
	FU_build_install

	FU_build_finishinstall
fi
