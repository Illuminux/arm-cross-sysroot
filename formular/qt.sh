#!/bin/bash

URL="http://download.qt-project.org/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"

DEPEND=()

ARGS=(
	"--host=${TARGET}"
	"--enable-shared"
	"--disable-static"
)

get_names_from_url
QT_DIR="Qt-${VERSION}-${BOARD}"

echo "Build $NAME:"
if ! [ -d "/usr/local/Trolltech/${QT_DIR}" ]; then

	get_download
	extract_tar

	MKSPECS_DIR="${SOURCE_DIR}/${DIR_NAME}/mkspecs/qws/${TARGET}-g++"

	mkdir $MKSPECS_DIR
	cp \
		"${SOURCE_DIR}/${DIR_NAME}/mkspecs/qws/linux-arm-g++/qplatformdefs.h" \
		"${MKSPECS_DIR}/"	

	echo "# qmake configuration for building for ${BOARD}" > "${MKSPECS_DIR}/qmake.conf"
	echo "#" >> "${MKSPECS_DIR}/qmake.conf"
	echo "" >> "${MKSPECS_DIR}/qmake.conf"
	echo "include(../../common/linux.conf)" >> "${MKSPECS_DIR}/qmake.conf"
	echo "include(../../common/gcc-base-unix.conf)" >> "${MKSPECS_DIR}/qmake.conf"
	echo "include(../../common/g++-unix.conf)" >> "${MKSPECS_DIR}/qmake.conf"
	echo "include(../../common/qws.conf)" >> "${MKSPECS_DIR}/qmake.conf"
	echo "" >> "${MKSPECS_DIR}/qmake.conf"
	echo "#Toolchain" >> "${MKSPECS_DIR}/qmake.conf"
	echo "" >> "${MKSPECS_DIR}/qmake.conf"
	echo "#Compiler Flags to take advantage of the ARM architecture" >> "${MKSPECS_DIR}/qmake.conf"

	if [ $BORAD == "beaglebone" ]; then 
		echo "QMAKE_CFLAGS_RELEASE =   -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard" >> "${MKSPECS_DIR}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard" >> "${MKSPECS_DIR}/qmake.conf"
	elif [ $BORAD == "raspi" ]; then
		echo "QMAKE_CFLAGS_RELEASE =   -O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard" >> "${MKSPECS_DIR}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard" >> "${MKSPECS_DIR}/qmake.conf"
	elif [ $BORAD == "hardfloat" ]; then
		echo "QMAKE_CFLAGS_RELEASE =   -O3 -mfloat-abi=hard" >> "${MKSPECS_DIR}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -mfloat-abi=hard" >> "${MKSPECS_DIR}/qmake.conf"
	fi

	echo "" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_CC         = ${TOOLCHAIN_BIN_DIR}/${TARGET}-gcc" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_CXX        = ${TOOLCHAIN_BIN_DIR}/${TARGET}-g++" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_LINK       = ${TOOLCHAIN_BIN_DIR}/${TARGET}-g++" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_LINK_SHLIB = ${TOOLCHAIN_BIN_DIR}/${TARGET}-g++" >> "${MKSPECS_DIR}/qmake.conf"
	echo "" >> "${MKSPECS_DIR}/qmake.conf"
	echo "# modifications to linux.conf" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_AR      = ${TOOLCHAIN_BIN_DIR}/${TARGET}-ar cqs" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_OBJCOPY = ${TOOLCHAIN_BIN_DIR}/${TARGET}-objcopy" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_STRIP   = ${TOOLCHAIN_BIN_DIR}/${TARGET}-strip" >> "${MKSPECS_DIR}/qmake.conf"
	echo "" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/alsa" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/dbus-1.0" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/freetype2" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/glib-2.0" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/gstreamer-0.11" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/libpng12" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/libxml2" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/openssl" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_INCDIR += ${SYSROOT_DIR}/include/X11" >> "${MKSPECS_DIR}/qmake.conf"
	echo "QMAKE_LIBDIR += ${SYSROOT_DIR}/lib" >> "${MKSPECS_DIR}/qmake.conf"
	echo "" >> "${MKSPECS_DIR}/qmake.conf"
	echo "load(qt_config)" >> "${MKSPECS_DIR}/qmake.conf"

	cd "${SOURCE_DIR}/${DIR_NAME}"

	echo -n "  Configure ${NAME}... "
	./configure -v \
		-opensource \
		-confirm-license \
		-prefix /usr/local/Trolltech/${QT_DIR} \
		-embedded arm \
		-platform qws/linux-x86-g++ \
		-xplatform qws/${TARGET}-g++ \
		-depths 16,24,32 \
		-no-mmx \
		-no-3dnow \
		-no-sse \
		-no-sse2 \
		-no-ssse3 \
		-no-cups \
		-no-largefile \
		-no-accessibility \
		-no-gtkstyle \
		-qt-mouse-pc \
		-qt-mouse-linuxtp \
		-qt-mouse-linuxinput \
		-plugin-mouse-linuxtp \
		-plugin-mouse-pc \
		-fast \
		-little-endian \
		-host-little-endian \
		-no-pch \
		-no-sql-ibase \
		-no-sql-mysql \
		-no-sql-odbc \
		-no-sql-psql \
		-no-webkit \
		-no-freetype \
		-no-qt3support \
		-nomake examples \
		-nomake demos \
		-nomake docs \
		-nomake translations >$LOG_FILE 2>&1
	is_error "$?"

	build_make

	su_build_install

	build_finishinstall

	cd $BASE_DIR
else
	echo "... already installed"
fi

export CFLAGS="${CFLAGS} -I/usr/local/Trolltech/${QT_DIR}/include/Qt"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
export LDFLAGS="${LDFLAGS} -L/usr/local/Trolltech/${QT_DIR}/lib"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/Trolltech/${QT_DIR}/lib/pkgconfig"

