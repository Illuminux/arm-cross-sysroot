#!/bin/bash


##
## Run autogen script if no configure script exists 
##
FU_build_autogen() {
	
	# Go into source dir of the package 
	do_cd "${GV_source_dir}/${GV_dir_name}" 
	
	# Run if configure does not exists
	if ! [ -f "${GV_source_dir}/${GV_dir_name}/configure" ]; then
		
		echo -n "Autogen ${GV_name}... "
		
		if [ "$GV_debug" == true ]; then
			echo 
			./autogen.sh 2>&1 | tee $GV_log_file
			FU_tools_is_error "$?"
			
		else
			./autogen.sh >$GV_log_file 2>&1
			FU_tools_is_error "$?"
			
		fi
	fi
	
	# Go back to base dir
	do_cd $GV_base_dir
}


##
## Run configure script or print help 
##
FU_build_configure() {
	
	# Go into source dir of the package 
	do_cd "${GV_source_dir}/${GV_dir_name}"	
	
	# Print configure help
	echo -n "Configure ${GV_name}... "
	if [ "$GV_conf_help" == true ]; then
		./configure --help
		FU_tools_exit
		
	fi
	
	LIBS+=" "
	for depend in "${GV_depend[@]}"; do 
		LIBS+=$(pkg-config "${UV_sysroot_dir}/lib/pkgconfig/${depend}.pc" --libs-only-l)
	done
	export LIBS=$LIBS
	
	# Run configure script in debug mode
	if [ "$GV_debug" == true ]; then
		echo 
		./configure \
			--prefix="${UV_sysroot_dir}/${GV_host}" \
			${GV_args[@]} 2>&1 | tee $GV_log_file
		FU_tools_is_error "$?"
	
	# Run configure script and write output to log file
	else
		./configure --prefix="${UV_sysroot_dir}/${GV_host}" ${GV_args[@]} >$GV_log_file 2>&1
		FU_tools_is_error "$?"
	fi
	
	# Go back to base dir
	do_cd $GV_base_dir
}


##
## Run make script or print help 
##
FU_build_make() {
	
	# catch make arguments 
	if [ "${#}" -eq 0 ]; then 
		local args="-j4"
	else
		local args=$@
	fi

	# Go into source dir of the package 
	do_cd "${GV_source_dir}/${GV_dir_name}"

	echo -n "Make ${GV_name}... "
	
	# Run make script in debug mode
	if [ "$GV_debug" == true ]; then
		echo
		make $args 2>&1 | tee $GV_log_file
		FU_tools_is_error "$?"		
	
	# Run make script and write output to log file
	else
		make $args >$GV_log_file 2>&1
		FU_tools_is_error "$?"
		
	fi
	
	# Go back to base dir
	do_cd $GV_base_dir
}


##
## Run make install script
##
FU_build_install() {
	
	# catch make arguments 
	if [ "${#}" -eq 0 ]; then 
		local args="install"
	else
		local args=$@
	fi
	
	# Go into source dir of the package 
	do_cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Install ${GV_name}... "
	
	# Run make script in debug mode
	if [ "$GV_debug" == true ]; then
		echo
		make $args 2>&1 | tee $GV_log_file
		FU_tools_is_error "$?"
		
	# Run make script and write output to log file
	else
		make $args >$GV_log_file 2>&1
		FU_tools_is_error "$?"
		
	fi
	
	# Go back to base dir
	do_cd $GV_base_dir
	
	# Finish the installation 
	FU_build_finishinstall
}


##
## Finish the installation
##
FU_build_finishinstall() {

	local end_time=`date +%s`
	local build_time=`expr $end_time - $GV_build_start`
	
	rm -f $GV_log_file	
	echo -n " - ${GV_name} (${GV_version})" >> "${UV_sysroot_dir}/buildinfo.txt"
	echo    " - [$build_time sec]" >> "${UV_sysroot_dir}/buildinfo.txt"
	
	unset LIBS
}


##
## Write a pkg_config file
##
FU_build_pkg_file() {
	
	do_mkdir "${UV_sysroot_dir}/lib/pkgconfig/"

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
