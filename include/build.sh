#!/bin/bash

FU_build() {

	FU_build_autogen
	FU_build_configure
	if [ "${#}" -gt 0 ]; then 
		FU_build_make $@
	else
		FU_build_make
	fi
	
	FU_build_install
	
	FU_build_finishinstall
}


FU_build_autogen() {
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	if ! [ -f "${GV_source_dir}/${GV_dir_name}/configure" ]; then
		echo -n "Autogen ${GV_name}... "
		./autogen.sh >$GV_log_file 2>&1
		FU_is_error "$?"
	fi
	
	cd $GV_base_dir
}


FU_build_configure() {

	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Configure ${GV_name}... "
	if [ "$GV_conf_help" == true ]; then
		./configure --help
		exit
	elif [ "$GV_conf_show" == true ]; then
		echo "" >$GV_log_file 2>&1
		./configure --prefix="${UV_sysroot_dir}" ${GV_args[@]} 2>&1
		FU_is_error "$?"
	else
		./configure --prefix="${UV_sysroot_dir}" ${GV_args[@]} >$GV_log_file 2>&1
		FU_is_error "$?"
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
	if [ "$GV_make_show" == true ]; then
		make $LV_make_args 2>&1
		FU_is_error "$?"		
	else
		make $LV_make_args >$GV_log_file 2>&1
		FU_is_error "$?"
	fi

	cd $GV_base_dir
	
	unset LV_make_args
}


FU_build_install() {

	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Install ${GV_name}... "
	make install >$GV_log_file 2>&1
	FU_is_error "$?"

	cd $GV_base_dir
}


FU_su_build_install() {

	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Install as root ${GV_name}... "
	sudo make install >$GV_log_file 2>&1
	FU_is_error "$?"

	cd $GV_base_dir
}


FU_build_finishinstall() {

	LV_build_end=`date +%s`
	LV_build_time =`expr $LV_build_end - $GV_build_start`
	
	rm -f $GV_log_file	
	echo -n " - ${GV_name} (${GV_version})" >> "${UV_sysroot_dir}/buildinfo.txt"
	echo    " - [$LV_build_time sec]" >> "${UV_sysroot_dir}/buildinfo.txt"
	
	unset LV_build_end
	unset LV_build_time
}
