#!/bin/bash

build() {

	build_autogen
	build_configure
	if [ "${#}" -gt 0 ]; then 
		build_make $@
	else
		build_make
	fi
	
	if [ "${BUILD_AS_ROOT}" = true ]; then
		su_build_install
	else
		build_install
	fi
	
	build_finishinstall
}


build_autogen() {
	
	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	if ! [ -f "${SOURCE_DIR}/${DIR_NAME}/configure" ]; then
		echo -n "Autogen ${NAME}... "
		./autogen.sh >$LOG_FILE 2>&1
		is_error "$?"
	fi
	
	cd $BASE_DIR
}


build_configure() {

	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	echo -n "Configure ${NAME}... "
	if [ "$ARG_CONF_HELP" == true ]; then
		./configure --help
		exit
	elif [ "$ARG_CONF_SHOW" == true ]; then
		echo "" >$LOG_FILE 2>&1
		./configure --prefix="${SYSROOT_DIR}" ${ARGS[@]} 2>&1
		is_error "$?"
	else
		./configure --prefix="${SYSROOT_DIR}" ${ARGS[@]} >$LOG_FILE 2>&1
		is_error "$?"
	fi

	cd $BASE_DIR
}


build_make() {
	
	if [ "${#}" -eq 0 ]; then 
		MAKE_PARA="-j4"
	else
		MAKE_PARA=$@
	fi

	cd "${SOURCE_DIR}/${DIR_NAME}"

	echo -n "Make ${NAME}... "
	if [ "$ARG_MAKE_SHOW" == true ]; then
		make $MAKE_PARA 2>&1
		is_error "$?"		
	else
		make $MAKE_PARA >$LOG_FILE 2>&1
		is_error "$?"
	fi

	cd $BASE_DIR
}


build_install() {

	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	echo -n "Install ${NAME}... "
	make install >$LOG_FILE 2>&1
	is_error "$?"

	cd $BASE_DIR
}


su_build_install() {

	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	echo -n "Install as root ${NAME}... "
	sudo make install >$LOG_FILE 2>&1
	is_error "$?"

	cd $BASE_DIR
}


build_finishinstall() {

	BUILD_END=`date +%s`
	BUILD_TIME=`expr $BUILD_END - $BUILD_START`
	
	rm -f $LOG_FILE	
	echo -n " - ${NAME} (${VERSION})" >> "${SYSROOT_DIR}/buildinfo.txt"
	echo    " - [$BUILD_TIME sec]" >> "${SYSROOT_DIR}/buildinfo.txt"
	
}
