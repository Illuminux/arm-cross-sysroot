#!/bin/bash

##
## Test if is an error.
## If is error print error message and abort script
##
FU_tools_is_error() {
	
	local pipestatus=$PIPESTATUS
	local arg=$1
	
	if [ $pipestatus -eq 0 ]; then
		echo "donne"
	else
		
		if [ $arg == "configure" ]; then 
			if [ -f "${GV_source_dir}/${GV_dir_name}/config.log" ]; then 
				cp -f "${GV_source_dir}/${GV_dir_name}/config.log" \
					$GV_log_file
			fi
		fi		
				
		cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"
		
		echo
		echo 
		echo "*** Error in $GV_name ***"
		echo 
		echo "See '${GV_base_dir}/log/${GV_name}.log' for more details"
		echo
		
		FU_tools_cleanup_build 
		
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
	
	FU_tools_cleanup_build
	
	exit 1
}


##
## Exit script
##
FU_tools_exit() {

	FU_tools_cleanup_build
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


##
## Exit script if user has no access rights
##
FU_tools_must_have_sudo() {

	echo
	echo "*** Error ***"
	echo "Cannot write into directory '${UV_sysroot_dir}'."
	echo "Do nou run the script with 'sudo'!"
	echo
	FU_tools_cleanup_build
}


##
## Test access rights for building the sysroot
##
FU_tools_access_rights() {

	# Create sysroot dir and test access rights
	mkdir -p ${UV_sysroot_dir} >/dev/null 2>&1 \
		|| FU_tools_must_have_sudo
}


##
## Print usage/help if command line argument is -h or --help
##
FU_tools_print_usage() {

	echo "Usage: ${0} [Option]"
	echo
	echo "  Options:"
	echo "    -b | --build      Start building the sysroot."
	echo "    -a | --available  List all available formulas."
	echo "    -l | --list       List all instaled formulas."
	echo "    -l | --debug      Display configure and make output."
	echo "    --conf-help       Display the configure help for the new formula."
	echo "    -v | --version    Script Version"
	echo "    -h | --help       Display this message"
	echo
	exit 0
}

FU_tools_print_available() {
	
	local term_chars=$(tput cols) 
	local max_len=19
	local term_chars=$((term_chars-$max_len))
	local term_out=""

	echo 
	echo "Available formulas:"

	for LV_formula in "${GV_build_formulas[@]}"
	do 
		term_out=$((term_out+$max_len))
		
		if [ $term_out -gt $term_chars ]; then
			echo 
			term_out=0
		fi
		
		printf "%-20s" "$LV_formula"
	done
	
	echo
	exit 0
}


##
## Parse the command line arguments
##
FU_tools_parse_arguments() {
	
	local build=false
	
	if [ $# -eq 0 ]; then
		FU_tools_print_usage
		exit 0
	fi
	
	while [ "$1" != "" ]; do
		
		# Get the ext command line argument
		local param=$(echo $1 | gawk -F= '{print $1}')
		
		# Get the value - not needed at the moment
	    #local value=$(echo $1 | gawk -F= '{print $2}')
		
		case $param in
				
			-h | --help)
				FU_tools_print_usage
				exit 0
				;;
				
			-b | --build)
				build=true
				;;
				
			-l | --list)
				FU_tools_print_list
				exit 0
				;;
				
			-a | --available)
				FU_tools_print_available
				exit 0
				;;
				
			-d | --debug)
				GV_debug=true
				;;
				
			--conf-help)
				build=true
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
	
	if [ "$build" == false ]; then 
		exit 0
	fi
	
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
		FU_tools_is_error "hdiutil"
	else
		
		echo "already exists"
	fi
	
	# Mount image
	echo -n "Mounting Source Image... "
	
	if [ ! -d "${GV_source_dir}" ]; then 
		
		hdiutil attach "${GV_src_img_name}" \
			-mountroot $GV_base_dir >$GV_log_file 2>&1
		FU_tools_is_error "hdiutil"
		echo "mounted to ${GV_source_dir}"
	else
		
		echo "already mounted to ${GV_source_dir}"
	fi
}


##
## cleanup build dir
##
FU_tools_cleanup_build() {
	
	# Go into base dir
	do_cd $GV_base_dir

	printf "\nCleanup build directory:\n"
	
	if [ -d "${GV_source_dir}" ]; then
		
		if [ $GV_build_os = "Darwin" ]; then 
		
			echo -n "Unmount source image... " 
			hdiutil detach $GV_source_dir >/dev/null
			echo "done"
		
			echo -n "Renove source image... " 
			rm -rf "${GV_base_dir}/sources.sparseimage"
			echo "done"
		else
			echo -n "Renove source directory... " 
			rm -rf "${GV_base_dir}/src"
			echo "done"
		fi
	fi
	
	# remove lock file
	rm -f $GV_lock_file
}


FU_tools_check_depend() {
	return 0
}


