#!/bin/bash

URL="https://github.com/gumulka/BlackLib.git"

DEPEND=()

ARGS=()

get_names_from_url
installed "blacklib.pc"

if [ $? == 1 ]; then
	
	DIR_NAME=${DIR_NAME%.*}
	NAME=$DIR_NAME
	
	if ! [ -d "$DOWNLOAD_DIR" ]; then
		echo -n "  Create Download dir... "
		mkdir -p $DOWNLOAD_DIR >$LOG_FILE 2>&1
		is_error "$?"
		echo "done"
	fi
	
	cd $DOWNLOAD_DIR
	
	echo -n "Download ${NAME}... "
	if ! [ -d "${DOWNLOAD_DIR}/${DIR_NAME}" ]; then
		git clone $URL 2>&1
		is_error "$?"
	else
		echo "alredy loaded"
	fi
	
	if ! [ -d "$SOURCE_DIR" ]; then
		echo -n "Create source dir... "
		mkdir -p $SOURCE_DIR >$LOG_FILE 2>&1
		is_error "$?"
	fi
	
	echo -n "Copy ${NAME}... "
	if [ -d "${SOURCE_DIR}/${DIR_NAME}" ]; then
		rm -rf "${SOURCE_DIR}/${DIR_NAME}"
	fi
	cp -rf "${DOWNLOAD_DIR}/${DIR_NAME}" "${SOURCE_DIR}/${DIR_NAME}" >$LOG_FILE 2>&1
	is_error "$?"
	rm -rf "${SOURCE_DIR}/${DIR_NAME}/.git"
	
	
	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	patch -p1 < "${BASE_DIR}/patches/blacklib.patch" >$LOG_FILE 2>&1
	
	export CC=$TARGET-gcc
	export CXX=$TARGET-g++
	
	cd "${SOURCE_DIR}/${DIR_NAME}/v2_0"
	echo -n "Make ${NAME}... "
	if [ "$ARG_MAKE_SHOW" == true ]; then
		make -j4 2>&1
		is_error "$?"		
	else
		make -j4 >$LOG_FILE 2>&1
		is_error "$?"
	fi
	
	echo -n "Install ${NAME}... "
	make install DESTDIR=$SYSROOT_DIR >$LOG_FILE 2>&1
	is_error "$?"
	
	cd $BASE_DIR
	
	unset CC
	unset CXX
	
cat > "${SYSROOT_DIR}/lib/pkgconfig/blacklib.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include/BlackLib

Name: ${NAME}
Description: GPIO Interface library for the Beaglebone Black
Version: 2.0

EOF
fi
