#!/bin/bash

GV_url="http://download.qt-project.org/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"

DEPEND=(
	"libX11"
	"libXv"
)

GV_args=()

FU_tools_get_names_from_url
QT_DIR="Qt-${GV_version}-${UV_board}"

echo -n "Build $GV_name:"
if ! [ -d "/usr/local/Trolltech/${QT_DIR}" ]; then

	FU_file_get_download
	FU_file_extract_tar
	
	# patch for os x
	if [ $GV_build_os = "Darwin" ]; then 
		
		cd "${GV_source_dir}/${GV_dir_name}"
		echo -n "Patch ${GV_name}... "		
		patch -p1 < "${GV_base_dir}/patches/qt-mac_os_x.patch" >$GV_log_file 2>&1
		
		FU_tools_is_error "$?"
		
		cd $GV_base_dir
	fi
	
	
	if [ "${UV_board}" == "beaglebone" ]; then 
		
		MKSPECS_DIR="qws/linux-arm-beaglebone-gnueabihf-g++"
		
		QMAKE_CFLAGS_RELEASE="-O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard"
		QMAKE_CXXFLAGS_RELEASE="-O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard"
		
	elif [ "${UV_board}" == "raspi" ]; then
		
		MKSPECS_DIR="qws/linux-arm-raspi-gnueabihf-g++"
		
		QMAKE_CFLAGS_RELEASE="-O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard"
		QMAKE_CXXFLAGS_RELEASE="-O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard"
		
	elif [ "${UV_board}" == "hardfloat" ]; then
		
		MKSPECS_DIR="qws/linux-arm-gnueabihf-g++"
		
		QMAKE_CFLAGS_RELEASE="-O3 -mfloat-abi=hard"
		QMAKE_CXXFLAGS_RELEASE="-O3 -mfloat-abi=hard"
		
	else
		
		MKSPECS_DIR="qws/linux-arm-gnueabi-g++"
		
		QMAKE_CFLAGS_RELEASE=""
		QMAKE_CXXFLAGS_RELEASE=""
		
	fi
	

	mkdir "${GV_source_dir}/${GV_dir_name}/mkspecs/${MKSPECS_DIR}/"
	cp \
		"${GV_source_dir}/${GV_dir_name}/mkspecs/qws/linux-arm-g++/qplatformdefs.h" \
		"${GV_source_dir}/${GV_dir_name}/mkspecs/${MKSPECS_DIR}/"
	
cat > "${GV_source_dir}/${GV_dir_name}/mkspecs/${MKSPECS_DIR}/qmake.conf" << EOF
# qmake configuration for building for ${UV_board}
#
include(../../common/linux.conf)
include(../../common/gcc-base-unix.conf)
include(../../common/g++-unix.conf)
include(../../common/qws.conf)

#Toolchain

#Compiler Flags to take advantage of the ARM architecture
QMAKE_CFLAGS_RELEASE   = ${QMAKE_CFLAGS_RELEASE}
QMAKE_CXXFLAGS_RELEASE = ${QMAKE_CXXFLAGS_RELEASE}

QMAKE_CC         = ${UV_toolchain_dir}/bin/${UV_target}-gcc
QMAKE_CXX        = ${UV_toolchain_dir}/bin/${UV_target}-g++
QMAKE_LINK       = ${UV_toolchain_dir}/bin/${UV_target}-g++
QMAKE_LINK_SHLIB = ${UV_toolchain_dir}/bin/${UV_target}-g++

# modifications to linux.conf"
QMAKE_AR         = ${UV_toolchain_dir}/bin/${UV_target}-ar cqs
QMAKE_OBJCOPY    = ${UV_toolchain_dir}/bin/${UV_target}-objcopy
QMAKE_STRIP      = ${UV_toolchain_dir}/bin/${UV_target}-strip
QMAKE_READELF    = ${UV_toolchain_dir}/bin/${UV_target}-readelf

QMAKE_INCDIR    += ${UV_sysroot_dir}/include \\
                   ${UV_sysroot_dir}/include/dbus-1.0 \\
                   ${UV_sysroot_dir}/lib/dbus-1.0/include \\
                   ${UV_sysroot_dir}/include/glib-2.0 \\
                   ${UV_sysroot_dir}/lib/glib-2.0/include \\
                   ${UV_sysroot_dir}/include/gstreamer-0.10 \\
                   ${UV_sysroot_dir}/include/libxml2 \\

QMAKE_LIBDIR    += ${UV_sysroot_dir}/lib

QMAKE_LIBS      += -lz -ldl -lpthread -lgio-2.0 -lgobject-2.0 -lglib-2.0 \\ 
                   -lgmodule-2.0 -lresolv -lgthread-2.0 -lrt -lfusion \\
                   -lsqlite3 -lffi -ldbus-1 -lgstreamer-0.10 -ljpeg -lpng12 \\
                   -ldirectfb -ldirect -lXext -lX11 -lxcb -lXau

load(qt_config)
EOF

	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Configure ${GV_name}... "
	
	if [ $GV_build_os = "Darwin" ]; then 
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
			-nomake translations >$GV_log_file 2>&1
		FU_tools_is_error "$?"
		
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
			-nomake translations >$GV_log_file 2>&1
		FU_tools_is_error "$?"
	fi

	FU_build_make
	
	FU_build_su_install

	FU_build_finishinstall

	cd $GV_base_dir
else
	echo " already installed"
fi

export CFLAGS="${CFLAGS} -I/usr/local/Trolltech/${QT_DIR}/include"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
export LDFLAGS="${LDFLAGS} -L/usr/local/Trolltech/${QT_DIR}/lib"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/usr/local/Trolltech/${QT_DIR}/lib/pkgconfig"

