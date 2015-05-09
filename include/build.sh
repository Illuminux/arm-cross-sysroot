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
			FU_tools_is_error "autogen"
			
		else
			./autogen.sh >$GV_log_file 2>&1
			FU_tools_is_error "autogen"
			
		fi
	fi
	
	# Write bild.log into package log
	printf "\n\nAutogen %s:\n\n" ${GV_name} >> "${GV_log_dir}/${GV_name}.log"
	cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"
	
	# Go back to base dir
	do_cd $GV_base_dir
}


FU_build_expor_libs() {

	LIBS+=" "
	for depend in "${GV_depend[@]}"; do 
		LIBS+=$(pkg-config "${UV_sysroot_dir}/lib/pkgconfig/${depend}.pc" --libs-only-l)
	done
	export LIBS=$LIBS

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
	
	# Run configure script in debug mode
	if [ "$GV_debug" == true ]; then
		echo 
		./configure \
			${GV_args[@]} 2>&1 | tee $GV_log_file
		FU_tools_is_error "configure"
	
	# Run configure script and write output to log file
	else
		./configure ${GV_args[@]} >$GV_log_file 2>&1
		FU_tools_is_error "configure"
	fi
	
	# Write bild.log into package log
	printf "\n\nConfigure %s:\n\n" ${GV_name} >> "${GV_log_dir}/${GV_name}.log"
	cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"
	
	# Go back to base dir
	do_cd $GV_base_dir
}

##
## Run configure script or print help 
##
FU_build_configure_cmake() {
	
	# Go into source dir of the package 
	do_cd "${GV_source_dir}/${GV_dir_name}"
	
	# Print configure
	echo -n "Configure ${GV_name}... "
	
	# Run configure script in debug mode
	if [ "$GV_debug" == true ]; then
		echo	
		cmake ${GV_args[@]} 2>&1 | tee $GV_log_file
		FU_tools_is_error "cmake"
		
	# Run configure script and write output to log file
	else
		cmake ${GV_args[@]}	>$GV_log_file 2>&1
		FU_tools_is_error "cmake"
	fi
	
	# Write bild.log into package log
	printf "\n\nConfigure %s:\n\n" ${GV_name} >> "${GV_log_dir}/${GV_name}.log"
	cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"
	
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
		FU_tools_is_error "make"		
	
	# Run make script and write output to log file
	else
		make $args >$GV_log_file 2>&1
		FU_tools_is_error "make"
		
	fi
	
	# Write bild.log into package log
	printf "\n\nMake %s:\n\n" ${GV_name} >> "${GV_log_dir}/${GV_name}.log"
	cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"
	
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
		FU_tools_is_error "install"
		
	# Run make script and write output to log file
	else
		make $args >$GV_log_file 2>&1
		FU_tools_is_error "install"
		
	fi
	
	# Write bild.log into package log
	printf "\n\nInstall %s:\n\n" ${GV_name} >> "${GV_log_dir}/${GV_name}.log"
	cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"
	
	# Go back to base dir
	do_cd $GV_base_dir
	
}


##
## Run make install script
##
FU_build_install_sudo() {
	
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
		sudo make $args 2>&1 | tee $GV_log_file
		FU_tools_is_error "install"
		
	# Run make script and write output to log file
	else
		sudo make $args >$GV_log_file 2>&1
		FU_tools_is_error "install"
		
	fi
	
	# Write bild.log into package log
	printf "\n\nInstall %s:\n\n" ${GV_name} >> "${GV_log_dir}/${GV_name}.log"
	cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"
	
	# Go back to base dir
	do_cd $GV_base_dir
	
}


##
## Finish the installation
##
FU_build_finishinstall() {

	# calculate the build time
	local end_time=`date +%s`
	local build_time=`expr $end_time - $GV_build_start`
	
	# remove the build log file
	rm -f $GV_log_file	
	
	# compress the package log file
	do_cd $GV_log_dir
	tar -zcf "${GV_name}.tar.gz" "${GV_name}.log"
	rm "${GV_log_dir}/${GV_name}.log" 
	do_cd $GV_base_dir
	
	# prompt output
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
prefix=${UV_sysroot_dir}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: ${GV_name} Library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} $PKG_libs
Cflags: -I\${includedir}
EOF

	unset PKG_libs
	unset PKG_includedir
}