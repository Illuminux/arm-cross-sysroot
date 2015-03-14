#!/bin/bash

get_download(){
	
	if ! [ -d "$DOWNLOAD_DIR" ]; then
		echo -n "Create Download dir... "
		mkdir -p $DOWNLOAD_DIR >$LOG_FILE 2>&1
		is_error "$?"
		echo "done"
	fi
	
	echo -n "Download ${TAR_NAME}... "
	
	if ! [ -f "${DOWNLOAD_DIR}/${TAR_NAME}" ]; then
		echo 
		STATUS=$(curl -Lo "${DOWNLOAD_DIR}/${TAR_NAME}" -k# --write-out %{http_code} $URL)
		if [ $STATUS -ge 400 ]; then 
			rm -f ${DOWNLOAD_DIR}/${TAR_NAME}
			echo 
			echo "*** Error in $NAME ***"
			echo "HTTP Status ${STATUS}"
			echo "  Can not download: ${URL}"
			echo 
			exit 1
		fi
	else
		echo "alredy loaded"
	fi
}

extract_tar(){
	
	if ! [ -d "$SOURCE_DIR" ]; then
		echo -n "  Create source dir... "
		mkdir -p $SOURCE_DIR >$LOG_FILE 2>&1
		is_error "$?"
	fi
	
	echo -n "Extract ${TAR_NAME}... "
	
	if [ -d "${SOURCE_DIR}/${DIR_NAME}" ]; then
		rm -rf "${SOURCE_DIR}/${DIR_NAME}"
	fi
	
	cd $SOURCE_DIR
	
	if [ "${EXTENSION}" = "zip" ]; then
		unzip ${DOWNLOAD_DIR}/${TAR_NAME} >$LOG_FILE 2>&1
	else 
		tar xvf ${DOWNLOAD_DIR}/${TAR_NAME} >$LOG_FILE 2>&1
	fi

	is_error "$?"
	cd $BASE_DIR
	
	BUILD_START=`date +%s`
}