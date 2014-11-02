#!/bin/bash

URL="https://github.com/Itseez/opencv.git"

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
installed "${NAME}.pc"

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

cat > "${SOURCE_DIR}/${DIR_NAME}/platforms/linux/${TARGET}.toolchain.cmake" << EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_INSTALL_PREFIX $SYSROOT_DIR)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "")

set(CMAKE_C_COMPILER    $TOOLCHAIN_BIN_DIR/$TARGET-gcc)
set(CMAKE_CXX_COMPILER  $TOOLCHAIN_BIN_DIR/$TARGET-g++)

set(CMAKE_CXX_FLAGS "$CXXFLAGS -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi")
set(CMAKE_C_FLAGS   "$CFLAGS -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi")

set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now")
set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now")
set(CMAKE_EXE_LINKER_FLAGS    "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now")

set(ENABLE_NEON TRUE)
set(ENABLE_VFPV3 TRUE)

set(CMAKE_FIND_ROOT_PATH \${CMAKE_FIND_ROOT_PATH} "/usr" $TOOLCHAIN_DIR)


set(CMAKE_SKIP_RPATH TRUE CACHE BOOL "If set, runtime paths are not added when using shared libraries." )
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)

# macro to find programs on the host OS
macro( find_host_program )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 if( CMAKE_HOST_WIN32 )
  SET( WIN32 1 )
  SET( UNIX )
 elseif( CMAKE_HOST_APPLE )
  SET( APPLE 1 )
  SET( UNIX )
 endif()
 find_program( \${ARGN} )
 SET( WIN32 )
 SET( APPLE )
 SET( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endmacro()

# macro to find packages on the host OS
macro( find_host_package )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 if( CMAKE_HOST_WIN32 )
  SET( WIN32 1 )
  SET( UNIX )
 elseif( CMAKE_HOST_APPLE )
  SET( APPLE 1 )
  SET( UNIX )
 endif()
 find_package( \${ARGN} )
 SET( WIN32 )
 SET( APPLE )
 SET( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endmacro()
EOF
	
	echo -n "  Configure ${NAME}... "
	mkdir -p "${SOURCE_DIR}/${DIR_NAME}/build"
	cd "${SOURCE_DIR}/${DIR_NAME}/build"
	cmake \
		-DCMAKE_TOOLCHAIN_FILE="${SOURCE_DIR}/${DIR_NAME}/platforms/linux/${TARGET}.toolchain.cmake" \
			"${SOURCE_DIR}/${DIR_NAME}" >$LOG_FILE 2>&1
	is_error "$?"

	echo -n "  Make ${NAME}... "
	make >$LOG_FILE 2>&1
	is_error "$?"
	
	echo -n "  Install ${NAME}... "
	make install >$LOG_FILE 2>&1
	is_error "$?"
	
	cd $BASE_DIR
fi
