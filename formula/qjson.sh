#!/bin/bash

GV_url="https://github.com/flavio/qjson.git"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "QJson.pc"

if [ $? == 1 ]; then
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	
	if ! [ -d "$UV_download_dir" ]; then
		echo -n "  Create Download dir... "
		mkdir -p $UV_download_dir >$GV_log_file 2>&1
		is_error "$?"
		echo "done"
	fi
	
	cd $UV_download_dir
	
	echo -n "  Download ${GV_name}... "
	if ! [ -d "${UV_download_dir}/${GV_dir_name}" ]; then
		git clone $GV_url 2>&1
		is_error "$?"
	else
		echo "alredy loaded"
	fi
	
	if ! [ -d "$GV_source_dir" ]; then
		echo -n "  Create source dir... "
		mkdir -p $GV_source_dir >$GV_log_file 2>&1
		is_error "$?"
	fi
	
	echo -n "  Copy ${GV_name}... "
	if [ -d "${GV_source_dir}/${GV_dir_name}" ]; then
		rm -rf "${GV_source_dir}/${GV_dir_name}"
	fi
	cp -rf "${UV_download_dir}/${GV_dir_name}" "${GV_source_dir}/${GV_dir_name}" >$GV_log_file 2>&1
	is_error "$?"
	rm -rf "${GV_source_dir}/${GV_dir_name}/.git"
	
	
	echo -n "  Configure ${GV_name}... "
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	cd "${GV_source_dir}/${GV_dir_name}/build"
	cmake \
		-DCMAKE_SYSTEM_GV_name="Linux" \
		-DCMAKE_SYSTEM_GV_version=1 \
		-DCMAKE_SYSTEM_PROCESSOR="arm" \
		-DCMAKE_C_COMPILER="$UV_target-gcc" \
		-DCMAKE_CXX_COMPILER="$UV_target-g++" \
		-DCMAKE_FIND_ROOT_PATH="${CMAKE_FIND_ROOT_PATH} $UV_toolchain_dir" \
		-DCMAKE_INSTALL_GV_prefix="$UV_sysroot_dir" \
		-DQT_QMAKE_EXECUTABLE="/usr/local/Trolltech/Qt-4.8.6-${UV_board}/bin/qmake" \
			"${GV_source_dir}/${GV_dir_name}" >$GV_log_file 2>&1
	is_error "$?"
	
	
	echo -n "  Make ${GV_name}... "
	make -j4 $GV_log_file 2>&1
	is_error "$?"
	
	echo -n "  Install ${GV_name}... "
	make install >$GV_log_file 2>&1
	is_error "$?"
	
	cd $GV_base_dir
	
	build_finishinstall
fi
