#!/bin/bash

GV_url="http://download.qt-project.org/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"
GV_sha1="ddf9c20ca8309a116e0466c42984238009525da6"

GV_depend=()

FU_tools_get_names_from_url
QT_DIR="Qt-${GV_version}-${UV_board}"
FU_tools_installed "QtCore.pc"

if [ $? == 1 ]; then

	FU_tools_check_depend

	FU_file_get_download
	FU_file_extract_tar

#	export PKG_CONFIG_SYSROOT_DIR="${UV_sysroot_dir}/lib/pkgconfig"
	TMP_CFLAGS=$CFLAGS
	TMP_CFLAGS=$CPPFLAGS
	TMP_CXXFLAGS=$CXXFLAGS
	TMP_LDFLAGS=$LDFLAGS
	unset CFLAGS
	unset CPPFLAGS
	unset CXXFLAGS
	unset LDFLAGS


	# patch for os x
	if [ $GV_build_os = "Darwin" ]; then

		cd "${GV_source_dir}/${GV_dir_name}"
		echo -n "Patch ${GV_name}... "
		patch -p1 < "${GV_base_dir}/patches/qt-mac_os_x.patch" >$GV_log_file 2>&1

		FU_tools_is_error "patch"

		cd $GV_base_dir
	fi

	LV_mkspecs_dir="qws/linux-${UV_target}-${UV_board}-g++"

	mkdir -p "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/"
	cp -f \
		"${GV_source_dir}/${GV_dir_name}/mkspecs/qws/linux-arm-g++/qplatformdefs.h" \
		"${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/"

cat > "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf" << EOF
# qmake configuration for building for ${UV_board}
#
include(../../common/linux.conf)
include(../../common/gcc-base-unix.conf)
include(../../common/g++-unix.conf)
include(../../common/qws.conf)

EOF


	if [ "${UV_board}" == "beaglebone" ]; then 

		echo "QMAKE_CFLAGS_RELEASE = -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-armhf"

	elif [ "${UV_board}" == "raspi" ]; then

		echo "QMAKE_CFLAGS_RELEASE = -O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-raspi"

	elif [ "${UV_board}" == "hardfloat" ]; then

		echo "QMAKE_CFLAGS_RELEASE = -O3 -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-armhf"

	else

		echo "QMAKE_CFLAGS_RELEASE=" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE=" \
			>> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf"
		
		LV_qt_dir="${UV_qt_dir}/Qt4.8.6-arm"

	fi

cat >> "${GV_source_dir}/${GV_dir_name}/mkspecs/${LV_mkspecs_dir}/qmake.conf" << EOF

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
                   ${UV_sysroot_dir}/include/glib-2.0 \\
                   ${UV_sysroot_dir}/lib/glib-2.0/include \\
                   ${UV_sysroot_dir}/include/dbus-1.0 \\
                   ${UV_sysroot_dir}/lib/dbus-1.0/include \\
                   ${UV_sysroot_dir}/include/gstreamer-0.10 \\
                   ${UV_sysroot_dir}/include/libxml2

QMAKE_LIBDIR    += ${UV_sysroot_dir}/lib

QMAKE_LIBS      += -lpthread -lrt -ldl -lresolv -lz -ljpeg -llzma -lts \\
                   -lffi -lXv -lXext -lX11 -lxcb -lXau -lorc-0.4 \\
                   -lglib-2.0 -ldbus-1

load(qt_config)
EOF

	cd "${GV_source_dir}/${GV_dir_name}"

	GV_args=(
		"-v"
		"-prefix ${LV_qt_dir}"
		"-opensource"
		"-confirm-license"
		"-embedded arm"
		"-xplatform $LV_mkspecs_dir"
		"-depths 16,24,32"
		"-fast"
		"-little-endian"
		"-host-little-endian"
		"-no-3dnow"
		"-no-cups"
		"-no-largefile"
		"-no-mmx"
		"-no-phonon-backend"
		"-no-qt3support"
		"-no-sql-ibase"
		"-no-sql-psql"
		"-no-sql-mysql"
		"-no-sql-odbc"
		"-no-sse"
		"-no-sse2"
		"-no-ssse3"
		"-no-webkit"
		"-qt-mouse-linuxtp"
		"-qt-mouse-linuxinput"
		"-qt-mouse-pc"
		"-plugin-mouse-linuxtp"
		"-plugin-mouse-pc"
		"-nomake examples"
		"-nomake demos"
		"-nomake docs"
		"-nomake translations"
	)

	if [ $GV_build_os = "Darwin" ]; then

		GV_args+=("-force-pkg-config")
	else

		GV_args+=(
			"-platform qws/linux-x86-g++"
			"-no-accessibility"
			"-no-gtkstyle"
			"-no-pch"
		)
	fi
	
	FU_build_configure
	FU_build_make

	if [ $GV_build_os = "Darwin" ]; then
		FU_build_install
	else
		FU_build_install_sudo
	fi

	FU_build_finishinstall
	
	# link pkg config files
	ln -s $LV_qt_dir/lib/pkgconfig/* $PKG_CONFIG_PATH/
	
	# link header files 
	ln -s $LV_qt_dir/include/* /$UV_sysroot_dir/include/
	
	# link libraries 
	ln -s $LV_qt_dir/lib/libQtCore.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtNetwork.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtTest.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtDBus.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtScript.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtXml.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtDeclarative.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtScriptTools.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libphonon.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtGui.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtSql.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtMultimedia.so /$UV_sysroot_dir/lib/
	ln -s $LV_qt_dir/lib/libQtSvg.so /$UV_sysroot_dir/lib/
	
	cd $GV_base_dir

	export CFLAGS=$TMP_CFLAGS
	export CXXFLAGS=$TMP_CXXFLAGS
	export LDFLAGS=$TMP_LDFLAGS

fi