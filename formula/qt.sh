#!/bin/bash

URL="http://download.qt-project.org/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"

DEPEND=()

ARGS=(
)

get_names_from_url
QT_DIR="Qt-${VERSION}-${BOARD}"

echo "Build $NAME:"
if ! [ -d "/usr/local/Trolltech/${QT_DIR}" ]; then

	get_download
#	extract_tar
	
	# patch for os x
	if [ $(uname -s) = "Darwin" ]; then 
		
		echo -n "Patch ${NAME}... "		
		patch "${SOURCE_DIR}/${DIR_NAME}/mkspecs/qws/macx-generic-g++/qmake.conf" \
			< "${BASE_DIR}/patches/qt-mac_os_x.patch" >$LOG_FILE 2>&1
		is_error "$?"
	fi
	
	
	if [ "${BOARD}" == "beaglebone" ]; then 
		
		MKSPECS_DIR="qws/linux-arm-beaglebone-gnueabihf-g++"
		
		QMAKE_CFLAGS_RELEASE="-O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard"
		QMAKE_CXXFLAGS_RELEASE="-O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard"
		
	elif [ "${BOARD}" == "raspi" ]; then
		
		MKSPECS_DIR="qws/linux-arm-raspi-gnueabihf-g++"
		
		QMAKE_CFLAGS_RELEASE="-O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard"
		QMAKE_CXXFLAGS_RELEASE="-O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard"
		
	elif [ "${BOARD}" == "hardfloat" ]; then
		
		MKSPECS_DIR="qws/linux-arm-gnueabihf-g++"
		
		QMAKE_CFLAGS_RELEASE="-O3 -mfloat-abi=hard"
		QMAKE_CXXFLAGS_RELEASE="-O3 -mfloat-abi=hard"
		
	else
		
		MKSPECS_DIR="qws/linux-arm-gnueabi-g++"
		
		QMAKE_CFLAGS_RELEASE=""
		QMAKE_CXXFLAGS_RELEASE=""
		
	fi
	

	mkdir "${SOURCE_DIR}/${DIR_NAME}/mkspecs/${MKSPECS_DIR}/"
	cp \
		"${SOURCE_DIR}/${DIR_NAME}/mkspecs/qws/linux-arm-g++/qplatformdefs.h" \
		"${SOURCE_DIR}/${DIR_NAME}/mkspecs/${MKSPECS_DIR}/"
	
cat > "${SOURCE_DIR}/${DIR_NAME}/mkspecs/${MKSPECS_DIR}/qmake.conf" << EOF
# qmake configuration for building for ${BOARD}
#
include(../../common/linux.conf)
include(../../common/gcc-base-unix.conf)
include(../../common/g++-unix.conf)
include(../../common/qws.conf)

#Toolchain

#Compiler Flags to take advantage of the ARM architecture
QMAKE_CFLAGS_RELEASE   = ${QMAKE_CFLAGS_RELEASE}
QMAKE_CXXFLAGS_RELEASE = ${QMAKE_CXXFLAGS_RELEASE}

QMAKE_CC         = ${TOOLCHAIN_BIN_DIR}/${TARGET}-gcc
QMAKE_CXX        = ${TOOLCHAIN_BIN_DIR}/${TARGET}-g++
QMAKE_LINK       = ${TOOLCHAIN_BIN_DIR}/${TARGET}-g++
QMAKE_LINK_SHLIB = ${TOOLCHAIN_BIN_DIR}/${TARGET}-g++

# modifications to linux.conf"
QMAKE_AR         = ${TOOLCHAIN_BIN_DIR}/${TARGET}-ar cqs
QMAKE_OBJCOPY    = ${TOOLCHAIN_BIN_DIR}/${TARGET}-objcopy
QMAKE_STRIP      = ${TOOLCHAIN_BIN_DIR}/${TARGET}-strip
QMAKE_READELF    = ${TOOLCHAIN_BIN_DIR}/${TARGET}-readelf

QMAKE_INCDIR    += ${SYSROOT_DIR}/include \\
                   ${SYSROOT_DIR}/include/alsa \\
                   ${SYSROOT_DIR}/include/dbus-1.0 \\
                   ${SYSROOT_DIR}/lib/dbus-1.0/include \\
                   ${SYSROOT_DIR}/include/freetype2 \\
                   ${SYSROOT_DIR}/include/glib-2.0 \\
                   ${SYSROOT_DIR}/lib/glib-2.0/include \\
                   ${SYSROOT_DIR}/include/gstreamer-0.11 \\
                   ${SYSROOT_DIR}/include/libpng12 \\
                   ${SYSROOT_DIR}/include/libxml2 \\
                   ${SYSROOT_DIR}/include/openssl \\
                   ${SYSROOT_DIR}/include/X11

QMAKE_LIBDIR    += ${SYSROOT_DIR}/lib

QMAKE_LIBS      += -lz -ldl -lpthread -lgio-2.0 -lgobject-2.0 -lglib-2.0 \\ 
                   -lgmodule-2.0 -lresolv -lgthread-2.0 -lrt -lfusion \\
                   -lsqlite3 -lffi -ldbus-1 -lgstreamer-0.10 -ljpeg -lpng12 \\
                   -ldirectfb -ldirect -lXext -lX11 -lxcb -lXau

load(qt_config)
EOF

	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	echo -n "Configure ${NAME}... "
	
	if [ $(uname -s) = "Darwin" ]; then 
		./configure -v \
			-opensource \
			-confirm-license \
			-prefix /usr/local/Trolltech/$QT_DIR \
			-embedded arm \
			-xplatform $MKSPECS_DIR \
			-depths 16,24,32 \
			-fast \
			-little-endian \
			-host-little-endian \
			-force-pkg-config \
			-no-3dnow \
			-no-cups \
			-no-freetype \
			-no-largefile \
			-no-mmx \
			-no-phonon \
			-no-phonon-backend \
			-no-qt3support \
			-no-sql-ibase \
			-no-sql-psql \
			-no-sql-mysql \
			-no-sql-odbc \
			-no-sse \
			-no-sse2 \
			-no-ssse3 \
			-no-webkit \
			-qt-mouse-linuxtp \
			-qt-mouse-linuxinput \
			-qt-mouse-pc \
			-plugin-mouse-linuxtp \
			-plugin-mouse-pc \
			-nomake examples \
			-nomake demos \
			-nomake docs \
			-nomake translations >$LOG_FILE 2>&1
		is_error "$?"
	
	else
		
		./configure -v \
			-opensource \
			-confirm-license \
			-prefix /usr/local/Trolltech/$QT_DIR \
			-embedded arm \
			-platform qws/linux-x86-g++ \
			-xplatform $MKSPECS_DIR \
			-depths 16,24,32 \
			-fast \
			-little-endian \
			-host-little-endian \
			-no-accessibility \
			-no-3dnow \
			-no-cups \
			-no-freetype \
			-no-gtkstyle \
			-no-largefile \
			-no-mmx \
			-no-pch \
			-no-phonon \
			-no-phonon-backend \
			-no-qt3support \
			-no-sql-ibase \
			-no-sql-psql \
			-no-sql-mysql \
			-no-sql-odbc \
			-no-sse \
			-no-sse2 \
			-no-ssse3 \
			-no-webkit \
			-qt-mouse-linuxtp \
			-qt-mouse-linuxinput \
			-qt-mouse-pc \
			-plugin-mouse-linuxtp \
			-plugin-mouse-pc \
			-nomake examples \
			-nomake demos \
			-nomake docs \
			-nomake translations >$LOG_FILE 2>&1
		is_error "$?"
	fi

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

