#!/bin/bash

URL="https://github.com/flavio/qjson.git"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "QJson.pc"

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
	
	echo -n "  Download ${NAME}... "
	if ! [ -d "${DOWNLOAD_DIR}/${DIR_NAME}" ]; then
		git clone $URL 2>&1
		is_error "$?"
	else
		echo "alredy loaded"
	fi
	
	if ! [ -d "$SOURCE_DIR" ]; then
		echo -n "  Create source dir... "
		mkdir -p $SOURCE_DIR >$LOG_FILE 2>&1
		is_error "$?"
	fi
	
	echo -n "  Copy ${NAME}... "
	if [ -d "${SOURCE_DIR}/${DIR_NAME}" ]; then
		rm -rf "${SOURCE_DIR}/${DIR_NAME}"
	fi
	cp -rf "${DOWNLOAD_DIR}/${DIR_NAME}" "${SOURCE_DIR}/${DIR_NAME}" >$LOG_FILE 2>&1
	is_error "$?"
	rm -rf "${SOURCE_DIR}/${DIR_NAME}/.git"
	
	
	echo -n "  Configure ${NAME}... "
	mkdir -p "${SOURCE_DIR}/${DIR_NAME}/build"
	cd "${SOURCE_DIR}/${DIR_NAME}/build"
	cmake \
		-DCMAKE_SYSTEM_NAME="Linux" \
		-DCMAKE_SYSTEM_VERSION=1 \
		-DCMAKE_SYSTEM_PROCESSOR="arm" \
		-DCMAKE_C_COMPILER="$TARGET-gcc" \
		-DCMAKE_CXX_COMPILER="$TARGET-g++" \
		-DCMAKE_FIND_ROOT_PATH="${CMAKE_FIND_ROOT_PATH} $TOOLCHAIN_DIR" \
		-DCMAKE_INSTALL_PREFIX="$SYSROOT_DIR" \
		-DQT_QMAKE_EXECUTABLE="/usr/local/Trolltech/Qt-4.8.6-${BOARD}/bin/qmake" \
			"${SOURCE_DIR}/${DIR_NAME}" >$LOG_FILE 2>&1
	is_error "$?"
	
	
	echo -n "  Make ${NAME}... "
	make -j4 $LOG_FILE 2>&1
	is_error "$?"
	
	echo -n "  Install ${NAME}... "
	make install >$LOG_FILE 2>&1
	is_error "$?"
	
	cd $BASE_DIR
	
	build_finishinstall
fi
