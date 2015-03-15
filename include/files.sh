#!/bin/bash

get_download(){
	
	if ! [ -d "$UV_download_dir" ]; then
		echo -n "Create Download dir... "
		mkdir -p $UV_download_dir >$GV_log_file 2>&1
		is_error "$?"
		echo "done"
	fi
	
	echo -n "Download ${GV_tar_name}... "
	
	if ! [ -f "${UV_download_dir}/${GV_tar_name}" ]; then
		echo 
		LV_status=$(curl -Lo "${UV_download_dir}/${GV_tar_name}" -k# --write-out %{http_code} $GV_url)
		if [ $LV_status -ge 400 ]; then 
			rm -f ${UV_download_dir}/${GV_tar_name}
			echo 
			echo "*** Error in $GV_name ***"
			echo "HTTP Status ${LV_status}"
			echo "  Can not download: ${GV_url}"
			echo 
			exit 1
		fi
	else
		echo "alredy loaded"
	fi
	
	unset LV_status
}

extract_tar(){
	
	if ! [ -d "$GV_source_dir" ]; then
		echo -n "  Create source dir... "
		mkdir -p $GV_source_dir >$GV_log_file 2>&1
		is_error "$?"
	fi
	
	echo -n "Extract ${GV_tar_name}... "
	
	if [ -d "${GV_source_dir}/${GV_dir_name}" ]; then
		rm -rf "${GV_source_dir}/${GV_dir_name}"
	fi
	
	cd $GV_source_dir
	
	if [ "${GV_extension}" = "zip" ]; then
		unzip ${UV_download_dir}/${GV_tar_name} >$GV_log_file 2>&1
	else 
		tar xvf ${UV_download_dir}/${GV_tar_name} >$GV_log_file 2>&1
	fi

	is_error "$?"
	cd $GV_base_dir
	
	GV_build_start=`date +%s`
}