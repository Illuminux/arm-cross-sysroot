#!/bin/bash

if ! [ "${UV_board}" == "raspi" ]; then
	return
fi

GV_url="git://git.drogon.net/wiringPi"
GV_sha1=""

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "wiringPi.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	
	FU_file_git_clone	
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	# remove sudo from install file
	$SED -i 's/$sudo //g' "${GV_source_dir}/${GV_dir_name}/build"
	
	# disable hardware=`fgrep Hardware ...
	$SED -i 's/hardware=/#hardware=/g' "${GV_source_dir}/${GV_dir_name}/build"
	
	# remove sudo make uninstall from install file
	$SED -i 's/make uninstall/#make uninstall/g' "${GV_source_dir}/${GV_dir_name}/build"
	
	
	MAKEFILES=($(find . -name Makefile))
	
	for entry in ${MAKEFILES[*]}
	do
		$SED -i 's/gcc/arm-linux-gnueabihf-gcc/g' $entry
		$SED -i 's/\/local//g' $entry
		$SED -i 's,/usr,'"$UV_sysroot_dir"',g' $entry
		$SED -i 's/\@ldconfig//g' $entry
		$SED -i 's/\@cp gpio/#\@cp gpio/g' $entry
		$SED -i 's/\@chown/#\@chown/g' $entry
		$SED -i 's/\@chmod/#\@chmod/g' $entry
		$SED -i 's/$Q $(LDCONFIG)/#$Q $(LDCONFIG)/g' $entry
		$SED -i 's/$Q chown/#$Q chown/g' $entry
		
		if [ "${entry}" ==  "./devLib/Makefile" ]; then
			$SED -i 's,INCLUDE	= -I.,'"INCLUDE	= -I. -I$UV_sysroot_dir/include"',g' $entry
		fi
	done
	
	echo -n "Build and Install ${GV_name}... "
	chmod +x build
	if [ "$GV_debug" == true ]; then
		./build 2>&1  | tee $GV_log_file
		FU_tools_is_error "install"
	else
		./build >$GV_log_file 2>&1
		FU_tools_is_error "install"
	fi
	
	cd $GV_base_dir
	
	PKG_libs="-lwiringPi"
	PKG_includedir=""
	
	FU_build_pkg_file	
	FU_build_finishinstall
	
fi