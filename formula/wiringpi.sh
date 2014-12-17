#!/bin/bash

URL="git://git.drogon.net/wiringPi"

DEPEND=()

ARGS=()

get_names_from_url
installed "wiringPi.pc"

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
	
	# remove sudo from install file
	sed -e 's/sudo //g' build > build.sh
	
	MAKEFILES=($(find . -name Makefile))
	
	for entry in ${MAKEFILES[*]}
	do
		cp $entry "${entry}.ori"
		sed -e 's/gcc/arm-linux-gnueabihf-gcc/g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\/local//g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's,/usr,'"$SYSROOT_DIR"',g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@ldconfig//g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@cp gpio/#\@cp gpio/g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@chown/#\@chown/g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@chmod/#\@chmod/g' "${entry}.ori" > $entry
		
		if [ "${entry}" ==  "./devLib/Makefile" ]; then
			cp $entry "${entry}.ori"
			sed -e 's,INCLUDE	= -I.,'"INCLUDE	= -I. -I$SYSROOT_DIR/include"',g' "${entry}.ori" > $entry
		fi
		
		
		rm -f "${entry}.ori"
	done
	
	echo -n "Build and Install ${NAME}... "
	chmod +x build.sh
	./build.sh >$LOG_FILE 2>&1
	is_error "$?"
	
	cd $BASE_DIR
	
	build_finishinstall
	
cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${NAME}
Description: GPIO Interface library for the Raspberry Pi
Version: 

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lpthread
Cflags: -I\${includedir}
EOF
fi
