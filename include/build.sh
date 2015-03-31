#!/bin/bash


FU_build_autogen() {
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	if ! [ -f "${GV_source_dir}/${GV_dir_name}/configure" ]; then
		
		echo -n "Autogen ${GV_name}... "
		
		if [ "$GV_debug" == true ]; then
			echo 
			./autogen.sh 2>&1 | tee $GV_log_file
			echo -n "Autogen ${GV_name}... "
			FU_tools_is_error "$?"
			
		else
			./autogen.sh >$GV_log_file 2>&1
			FU_tools_is_error "$?"
			
		fi
	fi
	
	cd $GV_base_dir
}


FU_build_configure() {

	cd "${GV_source_dir}/${GV_dir_name}"	
	
	echo -n "Configure ${GV_name}... "
	if [ "$GV_conf_help" == true ]; then
		./configure --help
		exit 0
		## Add exit function
	fi
		
	if [ "$GV_debug" == true ]; then
		echo 
		./configure \
			--prefix="${UV_sysroot_dir}/${GV_host}" \
			${GV_args[@]} 2>&1 | tee $GV_log_file
		echo -n "Configure ${GV_name}... "
		FU_tools_is_error "$?"
		
	else
		./configure --prefix="${UV_sysroot_dir}/${GV_host}" ${GV_args[@]} >$GV_log_file 2>&1
		FU_tools_is_error "$?"
	fi

	cd $GV_base_dir
}


FU_build_make() {
	
	if [ "${#}" -eq 0 ]; then 
		LV_make_args="-j4"
	else
		LV_make_args=$@
	fi

	cd "${GV_source_dir}/${GV_dir_name}"

	echo -n "Make ${GV_name}... "
	
	if [ "$GV_debug" == true ]; then
		echo
		make $LV_make_args 2>&1 | tee $GV_log_file
		echo -n "Make ${GV_name}... "
		FU_tools_is_error "$?"		
		
	else
		make $LV_make_args 2>&1
		FU_tools_is_error "$?"
		
	fi

	cd $GV_base_dir
	
	unset LV_make_args
}


FU_build_install() {
	
	if [ "${#}" -eq 0 ]; then 
		LV_make_args="install"
	else
		LV_make_args=$@
	fi
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Install ${GV_name}... "
	
	if [ "$GV_debug" == true ]; then
		echo
		make $LV_make_args 2>&1 | tee $GV_log_file
		echo -n "Install ${GV_name}... "
		FU_tools_is_error "$?"
		
	else
		make $LV_make_args >$GV_log_file 2>&1
		FU_tools_is_error "$?"
		
	fi

	cd $GV_base_dir
	
	FU_build_finishinstall
}


FU_build_finishinstall() {

	LV_build_end=`date +%s`
	LV_build_time=`expr $LV_build_end - $GV_build_start`
	
	rm -f $GV_log_file	
	echo -n " - ${GV_name} (${GV_version})" >> "${UV_sysroot_dir}/buildinfo.txt"
	echo    " - [$LV_build_time sec]" >> "${UV_sysroot_dir}/buildinfo.txt"
	
	unset LV_build_end
	unset LV_build_time
}


FU_build_pkg_file() {
	
	mkdir -p "${UV_sysroot_dir}/lib/pkgconfig/"

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: ${GV_name} Library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} $1
Cflags: -I\${includedir}
EOF
}
