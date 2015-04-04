#!/bin/bash

if ! [ "${UV_board}" == "beaglebone" ]; then
	return
fi

GV_url="https://github.com/gumulka/BlackLib.git"
GV_sha1=""

GV_args=()

FU_tools_get_names_from_url
GV_version="2.0"
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export CC=$UV_target-gcc
	export CXX=$UV_target-g++

	GV_depend=()
		
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	
	FU_file_git_clone
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	patch -p1 < "${GV_base_dir}/patches/blacklib.patch" >$GV_log_file 2>&1
	
	cd "${GV_source_dir}/${GV_dir_name}/v2_0"
	echo -n "Make ${GV_name}... "
	if [ "$GV_debug" == true ]; then
		make -j4 2>&1
		FU_tools_is_error "$?"		
	else
		make -j4 >$GV_log_file 2>&1
		FU_tools_is_error "$?"
	fi
	
	echo -n "Install ${GV_name}... "
	make install DESTDIR=$UV_sysroot_dir >$GV_log_file 2>&1
	FU_tools_is_error "$?"
	
	cd $GV_base_dir
	
	unset CC
	unset CXX
	
cat > "${UV_sysroot_dir}/lib/pkgconfig/blacklib.pc" << EOF
prefix=${UV_sysroot_dir}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include/BlackLib

Name: ${GV_name}
Description: GPIO Interface library for the Beaglebone Black
Version: ${GV_version}

EOF
fi
