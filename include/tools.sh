#!/bin/bash

##
## Test if is an error.
## If is error print error message and abort script
##
FU_tools_is_error() {
	
	if [ $PIPESTATUS -eq 0 ]; then
		echo "donne"
	else
		
		if ! [ "$GV_debug" == true ]; then
			echo "faild"
			cat $GV_log_file
		else
			echo "PIPESTATUS: ${PIPESTATUS}"
		fi
		
		echo 
		echo "*** Error in $GV_name ***"
		echo 
		exit 1
	fi
}


##
## Print error message and abort script
##
FU_tools_error() {

	echo "faild"
	cat $GV_log_file

	echo 
	echo "*** Error in $GV_name ***"
	echo 
	exit 1
}


##
## Exit script
##
FU_tools_exit() {

	exit 0
}


##
## Get the tar name from GV_url
##
FU_tools_get_names_from_url() {

	GV_tar_name=${GV_url##*/}
	FU_tools_get_names_from_dir_name $GV_tar_name
}


##
## Get name, directory name, version and extension from tar name 
##
FU_tools_get_names_from_dir_name() {
	
	GV_dir_name=${1%.tar.*}
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
	GV_extension=${GV_tar_name##*.}
}


##
## Test if formula already is installed 
##
FU_tools_installed() {
	
	echo -n "Build ${GV_name}:"
	
	if [ -f "${UV_sysroot_dir}/lib/pkgconfig/$1" ]; then
		FU_tools_pkg_version "${UV_sysroot_dir}/lib/pkgconfig/$1"
		if [ $? == 1 ]; then
			echo " updating"
		else
			echo " already installed (${GV_version})"
			return 0
		fi
	elif [ -f "${UV_sysroot_dir}/usr/lib/pkgconfig/$1" ]; then
		FU_tools_pkg_version "${UV_sysroot_dir}/usr/lib/pkgconfig/$1"
		if [ $? == 1 ]; then
			echo " updating"
		else
			echo " already installed (${GV_version})"
			return 0
		fi
	elif [ -f "${UV_sysroot_dir}/usr/local/lib/pkgconfig/$1" ]; then
		FU_tools_pkg_version "${UV_sysroot_dir}/usr/local/lib/pkgconfig/$1"
		if [ $? == 1 ]; then
			echo " updating"
		else
			echo " already installed (${GV_version})"
			return 0
		fi
	else
		echo
	fi
	
	touch -f "${GV_log_dir}/${GV_name}.log"
	rm -f "${GV_log_dir}/${GV_name}.tar.gz"
	
	return 1
}


FU_tools_pkg_version() {

	if ! [ $(pkg-config --modversion ${1}) = "${GV_version}" ]; then
		return 1
	else
		return 0
	fi
}


FU_tools_must_have_sudo() {

	 echo "Cannot write into directory \"${UV_sysroot_dir}\"."
	 echo "You can run the script by typing \"sudo $0\"."
	 exit 1
}


# test access rights for building the sysroot
FU_tools_access_rights() {

	# Create sysroot dir and test access rights
	mkdir -p ${UV_sysroot_dir} >/dev/null 2>&1 \
		|| FU_tools_must_have_sudo
}


FU_tools_print_usage() {

	echo "Usage: ${0} [Option]"
	echo
	echo "  Options:"
	echo "    --list             List all formulas."
	echo "    --debug           Display configure and make output."
	echo "    --configure-show  Display the configure output for the new formula."
	echo "    --version			 Script Version"
	echo "    --help             Display this message"
	echo
	exit 0
}

FU_tools_print_list() {

	echo 
	echo "Available formulas:"
	
	for LV_formula in "${GV_build_formulas[@]}"; do 
		LV_name=${LV_formula%;*}
		echo "${LV_name}"
	done
	
	echo
	exit 0
}

FU_tools_print_listinfo() {

	echo 
	echo "Available formulas:"
	
	for LV_formula in "${GV_build_formulas[@]}"; do 
		LV_name=${LV_formula%;*}
		LV_info=${LV_formula##*;}
		echo "${LV_name}:"
		echo $LV_info
		echo
	done
	
	echo
	exit 0
}


FU_tools_parse_arguments() {
	
	while [ "$1" != "" ]; do
		
		local param=$(echo $1 | gawk -F= '{print $1}')
	    local value=$(echo $1 | gawk -F= '{print $2}')
		
		case $param in
				
			-h | --help)
				FU_tools_print_usage
				exit 0
				;;
				
			-l | --list)
				FU_tools_print_list
				exit 0
				;;
				
			--debug)
				GV_debug=true
				;;
				
			--configure-help)
				GV_conf_help=true
				;;
				
			-v | --version)
				echo "${GV_version} (Build ${GV_build_date})"
				exit 0
				;;
				
			*)
				echo "ERROR: unknown parameter \"$param\""
				FU_tools_print_usage
				exit 1
				;;
		esac
		
		shift
	done
	
}


##
## Mac OS X only:
## Create an case senitive disk image and mount it for building the sources
## 
FU_tools_create_source_image(){
	
	# Create image if not exists 
	echo -n "Create Case-Sensitive Disk Image for Sources... "
	
	# Go into base dir
	do_cd $GV_base_dir
	
	if [ ! -f "${GV_src_img_name}" ]; then
		
		hdiutil create "${GV_src_img_name}" \
			-type SPARSE \
			-fs JHFS+X \
			-size $GV_src_img_size \
			-volname src  >$GV_log_file 2>&1
		FU_tools_is_error "$?"
	else
		
		echo "already exists"
	fi
	
	
	# Mount image
	echo -n "Mounting Source Image... "
	
	if [ ! -d "${GV_source_dir}" ]; then 
		
		hdiutil attach "${GV_src_img_name}" \
			-mountroot $GV_base_dir >$GV_log_file 2>&1
		FU_tools_is_error "$?"
		echo "mounted to ${GV_source_dir}"
	else
		
		echo "already mounted to ${GV_source_dir}"
	fi
}


FU_tools_check_depend() {
	return 0
}


