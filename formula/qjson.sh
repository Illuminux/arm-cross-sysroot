#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="https://github.com/flavio/qjson/archive/0.8.1.tar.gz"
	GV_sha1="4e93303ffd6a16326b144788466b77587f082d92"
else
	GV_url="https://github.com/flavio/qjson/archive/0.7.1.tar.gz"
	GV_sha1="435adaf6924588e59fae9b9680b06b8af55d5ee6"
fi

GV_depend=(
	"qt"
)

FU_tools_get_names_from_url

if [ "${UV_dist}" == "jessie" ]; then
	GV_dir_name="qjson-0.8.1"
	GV_name=${GV_dir_name%-*}
	GV_version="0.8.1"
else
	GV_dir_name="qjson-0.7.1"
	GV_name=${GV_dir_name%-*}
	GV_version="0.7.1"
fi

if [ -f "${PKG_CONFIG_PATH}/Qt5Core.pc" ]; then 
	echo "Build ${GV_name}... build in Qt5"
	return
fi

FU_tools_installed "QJson.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	GV_build_start=`date +%s`
	
	if [ "${UV_board}" == "beaglebone" ]; then 
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-armhf"

	elif [ "${UV_board}" == "raspi" ]; then
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-raspi"

	elif [ "${UV_board}" == "hardfloat" ]; then
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-armhf"

	else	
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-arm"

	fi
	
	GV_args=(
		"-DCMAKE_SYSTEM_NAME='Linux'"
		"-DCMAKE_SYSTEM_VERSION=1"
		"-DCMAKE_SYSTEM_PROCESSOR='arm'"
		"-DCMAKE_C_COMPILER='$UV_target-gcc'"
		"-DCMAKE_CXX_COMPILER='$UV_target-g++'"
		"-DCMAKE_FIND_ROOT_PATH='${CMAKE_FIND_ROOT_PATH} $UV_toolchain_dir'"
		"-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
		"-DQT_QMAKE_EXECUTABLE='${LV_qt_dir}/bin/qmake'"
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
