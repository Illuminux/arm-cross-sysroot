#!/bin/bash

##
## Download the pakcahe archive 
##
FU_file_get_download(){
	
	# If download dir dows not exist	
	if ! [ -d "$UV_download_dir" ]; then
		echo -n "Create Download dir... "
		do_mkdir $UV_download_dir
		echo "done"
	fi
	
	echo -n "Download ${GV_tar_name}... "
	
	# If package archive has not loaded
	if ! [ -f "${UV_download_dir}/${GV_tar_name}" ]; then
		echo 
		local status=$(curl \
			-Lo "${UV_download_dir}/${GV_tar_name}" \
			-# --write-out %{http_code} $GV_url)
		
		# If sever is not reachable
		if [ $status -ge 400 ]; then 
			rm -f ${UV_download_dir}/${GV_tar_name}

			echo "HTTP Status ${status}: " >$GV_log_file
			echo "  Can not download: ${GV_url}" >>$GV_log_file
			FU_tools_error
		fi
	
	# If package archive has loaded
	else
		echo "alredy loaded"
	fi
}


##
## Clone the package from git 
##
FU_file_git_clone(){

	# If download dir does not exist	
	if ! [ -d "$UV_download_dir" ]; then
		echo -n "  Create Download dir... "
		do_mkdir $UV_download_dir
		echo "done"
	fi
	
	do_cd $UV_download_dir
	
	# Clone the package
	echo -n "Download ${GV_name}... "
	if ! [ -d "${UV_download_dir}/${GV_dir_name}" ]; then
		git clone $GV_url 2>&1
		FU_tools_is_error "clone"
	else
		echo "alredy loaded"
	fi
	
	# Create a source dir for the package
	if ! [ -d "$GV_source_dir" ]; then
		echo -n "  Create source dir... "
		do_mkdir $GV_source_dir >$GV_log_file
	fi
	
	# Copy file to source dir
	echo -n "Copy ${GV_name}... "
	if [ -d "${GV_source_dir}/${GV_dir_name}" ]; then
		rm -rf "${GV_source_dir}/${GV_dir_name}"
	fi
	do_cpdir "${UV_download_dir}/${GV_dir_name}" \
		"${GV_source_dir}/${GV_dir_name}"
	rm -rf "${GV_source_dir}/${GV_dir_name}/.git"
	
	GV_build_start=`date +%s`
}


##
## Extract package archive
## 
FU_file_extract_tar(){
	
	# If download dir does not exist	
	if ! [ -d "$GV_source_dir" ]; then
		echo -n "  Create source dir... "
		do_mkdir $GV_source_dir
		echo "done"
	fi
	
	echo -n "Extract ${GV_tar_name}... "
	
	# Test package archive cecksum 
	if ! [ $GV_sha1 = $(openssl sha1 "${UV_download_dir}/${GV_tar_name}" | awk '{print $2}') ]; then
		
		echo "$GV_name: ${GV_tar_name} is not a valid archive!" >$GV_log_file
		FU_tools_error
	fi
	
	if [ -d "${GV_source_dir}/${GV_dir_name}" ]; then
		rm -rf "${GV_source_dir}/${GV_dir_name}"
	fi
	
	cd $GV_source_dir
	
	# Extract package archive
	if [ "${GV_extension}" = "zip" ]; then
		
		if [ "$GV_debug" == true ]; then
			unzip -o ${UV_download_dir}/${GV_tar_name} 2>&1 | tee $GV_log_file
			FU_tools_is_error "extract"
		else
			unzip -o ${UV_download_dir}/${GV_tar_name} >$GV_log_file 2>&1
			FU_tools_is_error "extract"
		fi
	else 
		
		if [ "$GV_debug" == true ]; then
			tar xvf ${UV_download_dir}/${GV_tar_name} 2>&1 | tee $GV_log_file
			FU_tools_is_error "extract"
		else
			tar xvf ${UV_download_dir}/${GV_tar_name} >$GV_log_file 2>&1
			FU_tools_is_error "extract"
		fi
	fi
	
	# Write bild.log into package log
	printf "\n\nExtract %s:\n\n" ${GV_name} >> "${GV_log_dir}/${GV_name}.log"
	cat $GV_log_file >> "${GV_log_dir}/${GV_name}.log"

	do_cd $GV_base_dir
	
	GV_build_start=`date +%s`
}