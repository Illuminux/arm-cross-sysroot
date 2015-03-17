#!/bin/bash

##
## Print error message and abort script
##
FU_is_error() {
	
	if [ "$1" == "0" ]; then
		echo "donne"
	else
		echo "faild"
		cat $GV_log_file
		echo 
		echo "*** Error in $GV_name ***"
		echo 
		exit 1
	fi
}


##
## Get the tar name from GV_url
##
FU_get_names_from_url() {

	GV_tar_name=${GV_url##*/}
	FU_get_names_from_dir_name $GV_tar_name
}


##
## Get name, directory name, version and extension from tar name 
##
FU_get_names_from_dir_name() {
	
	GV_dir_name=${1%.tar.*}
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
	GV_extension=${GV_tar_name##*.}
}


##
## Test if formula already is installed 
##
FU_installed() {
	
	echo -n "Build ${GV_name}:"
	
	if [ -f "${UV_sysroot_dir}/lib/pkgconfig/$1" ]; then
		FU_pkg_version "${UV_sysroot_dir}/lib/pkgconfig/$1"
		if [ $? == 1 ]; then
			echo " updating"
			return 1
		else
			echo " already installed"
			return 0
		fi
	elif [ -f "${UV_sysroot_dir}/usr/lib/pkgconfig/$1" ]; then
		FU_pkg_version "${UV_sysroot_dir}/usr/lib/pkgconfig/$1"
		if [ $? == 1 ]; then
			echo " updating"
			return 1
		else
			echo " already installed"
			return 0
		fi
	elif [ -f "${UV_sysroot_dir}/usr/local/lib/pkgconfig/$1" ]; then
		FU_pkg_version "${UV_sysroot_dir}/usr/local/lib/pkgconfig/$1"
		if [ $? == 1 ]; then
			echo " updating"
			return 1
		else
			echo " already installed"
			return 0
		fi
	else
		echo
		return 1
	fi
}


FU_pkg_version() {

	if ! [ $(pkg-config --modversion ${1}) = "${GV_version}" ]; then
		return 1
	else
		return 0
	fi
}


FU_must_have_sudo() {

	 echo "Cannot write into directory \"${UV_sysroot_dir}\"."
	 echo "You can run the script by typing \"sudo $0\"."
	 exit 1
}


FU_access_rights() {
	
	# test access rights for building the sysroot
	if ! [ -d ${UV_sysroot_dir} ]; then
		mkdir -p "${UV_sysroot_dir}" >/dev/null 2>&1 \
			|| FU_must_have_sudo
	else
		touch "${UV_sysroot_dir}/access_test" >/dev/null 2>&1 \
			&& rm -f "${UV_sysroot_dir}/access_test" \
			|| FU_must_have_sudo
	fi
}


FU_print_usage() {

	echo "Usage: ${0} [Option]"
	echo
	echo "  Options:"
	echo "    --list             List all formulas."
	echo "    --configure-help   Display the configure options for the first new formula."
	echo "    --configure-show   Display the configure output for the new formula."
	echo "    --make-show        Display the make output for the new formula."
	echo "    --help             Display this message"
	echo
	exit 0
}

FU_print_list() {

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


FU_parse_arguments() {
	
	LV_argv=($@)
	if [ $# -gt 0 ]; then 
		
		for GV_arg in "${LV_argv[@]}"; do

			case $GV_arg in
				"--list")
					FU_print_list
					;;
				"--configure-show")
					GV_conf_show=true
					;;
				"--configure-help")
					GV_conf_help=true
					;;
				"--make-show")
					GV_make_show=true
					;;
				*)
					FU_print_usage
			esac
		done
	fi
}


##
## Mac OS X only:
## Create an case senitive disk image and mount it for building the sources
## 
FU_create_source_image(){
	
	# Create image if not exists 
	echo -n "Create Case-Sensitive Disk Image for Sources... "
	
	if [ ! -f "${GV_src_img_name}" ]; then
		
		echo 
		
		hdiutil create "${GV_src_img_name}" \
			-type SPARSE \
			-fs JHFS+X \
			-size $GV_src_img_size \
			-volname src || error_hdiutil
	else
		
		echo "already exists"
	fi
	
	
	# Mount image
	echo -n "Mounting Source Image... "
	
	if [ ! -d "${GV_source_dir}" ]; then 
		
		hdiutil attach "${GV_src_img_name}" -mountroot $GV_base_dir >/dev/null 2>&1 || error_hdiutil
		echo "mounted to ${GV_source_dir}"
	else
		
		echo "already mounted to ${GV_source_dir}"
	fi
}


##
## Mac OS X only:
## Create an case senitive disk image and mount it for building the sources
## 
FU_create_sysroot_image(){
	
	# Create image if not exists 
	echo -n "Create Case-Sensitive Disk Image for Sysroot... "
	
	if [ ! -f "${GV_sys_img_name}" ]; then
		
		echo 
		
		hdiutil create "${GV_sys_img_name}" \
			-type SPARSE \
			-fs JHFS+X \
			-size $GV_sys_img_size \
			-volname sysroot || error_hdiutil
	else
		
		echo "already exists"
	fi
	
	
	# Mount image
	echo -n "Mounting Sysroot Image... "
	
	if [ ! -d "${UV_sysroot_dir}" ]; then 
		
		hdiutil attach "${GV_sys_img_name}" -mountroot "$GV_base_dir/.." >/dev/null 2>&1 || error_hdiutil
		echo "mounted to ${UV_sysroot_dir}"
	else
		
		echo "already mounted to ${UV_sysroot_dir}"
	fi
}

