#!/bin/bash

if ! [ "${UV_board}" == "beaglebone" ]; then
	return
fi

GV_url="https://github.com/gumulka/BlackLib.git"

DEPEND=()

GV_args=()

get_names_from_url
installed "blacklib.pc"

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
	
	echo -n "Download ${GV_name}... "
	if ! [ -d "${UV_download_dir}/${GV_dir_name}" ]; then
		git clone $GV_url 2>&1
		is_error "$?"
	else
		echo "alredy loaded"
	fi
	
	if ! [ -d "$GV_source_dir" ]; then
		echo -n "Create source dir... "
		mkdir -p $GV_source_dir >$GV_log_file 2>&1
		is_error "$?"
	fi
	
	echo -n "Copy ${GV_name}... "
	if [ -d "${GV_source_dir}/${GV_dir_name}" ]; then
		rm -rf "${GV_source_dir}/${GV_dir_name}"
	fi
	cp -rf "${UV_download_dir}/${GV_dir_name}" "${GV_source_dir}/${GV_dir_name}" >$GV_log_file 2>&1
	is_error "$?"
	rm -rf "${GV_source_dir}/${GV_dir_name}/.git"
	
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	patch -p1 < "${GV_base_dir}/patches/blacklib.patch" >$GV_log_file 2>&1
	
	export CC=$UV_target-gcc
	export CXX=$UV_target-g++
	
	cd "${GV_source_dir}/${GV_dir_name}/v2_0"
	echo -n "Make ${GV_name}... "
	if [ "$GV_make_show" == true ]; then
		make -j4 2>&1
		is_error "$?"		
	else
		make -j4 >$GV_log_file 2>&1
		is_error "$?"
	fi
	
	echo -n "Install ${GV_name}... "
	make install DESTDIR=$UV_sysroot_dir >$GV_log_file 2>&1
	is_error "$?"
	
	cd $GV_base_dir
	
	unset CC
	unset CXX
	
cat > "${UV_sysroot_dir}/lib/pkgconfig/blacklib.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include/BlackLib

Name: ${GV_name}
Description: GPIO Interface library for the Beaglebone Black
Version: 2.0

EOF
fi
