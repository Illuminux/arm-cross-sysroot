#!/bin/bash

GV_url="http://download.qt.io/official_releases/qt/5.4/5.4.1/single/qt-everywhere-opensource-src-5.4.1.tar.gz"
GV_sha1="e696b353a80ad53bcfd9535e744b5cd3246f5fd1"

GV_depend=()

FU_tools_get_names_from_url
QT_DIR="Qt-${GV_version}-${UV_board}"
FU_tools_installed "Qt5Core.pc"

if [ $? == 1 ]; then

	FU_tools_check_depend
	
	TMP_CFLAGS=$CFLAGS
	TMP_CFLAGS=$CPPFLAGS
	TMP_CXXFLAGS=$CXXFLAGS
	TMP_LDFLAGS=$LDFLAGS
	unset CFLAGS
	unset CPPFLAGS
	unset CXXFLAGS
	unset LDFLAGS

	FU_file_get_download
	FU_file_extract_tar
	
	export LIBS="-lrt -lpthread"
	
	if [ "${UV_board}" == "softfloat" ]; then
		device="linux-arm-gnueabi-g++"
		
		LV_qt_dir="${UV_qt_dir}/Qt5.4.1-arm"
		
	else
		device="linux-arm-gnueabihf-g++"
		rm -rf "${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}"
		cp -rf \
			"${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/linux-arm-gnueabi-g++" \
			"${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}"
		
		$SED -i "s/arm-linux-gnueabi/${UV_target}/g" \
			"${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}/qmake.conf"
	fi
	
	$SED -i "s/load(qt_config)//g" \
		"${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}/qmake.conf"
	
	
	if [ "${UV_board}" == "beaglebone" ]; then 

		# cannot compile with option -mfpu=neon!!!
		echo "QMAKE_CFLAGS_RELEASE = -O3 -march=armv7-a -mtune=cortex-a8 -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv7-a -mtune=cortex-a8 -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}/qmake.conf"
		
		LV_qt_dir="${UV_qt_dir}/Qt5.4.1-armhf"
	
	elif [ "${UV_board}" == "raspi" ]; then

		echo "QMAKE_CFLAGS_RELEASE = -O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}/qmake.conf"
		echo "QMAKE_CXXFLAGS_RELEASE = -O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard" \
			>> "${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}/qmake.conf"
		
		LV_qt_dir="${UV_qt_dir}/Qt5.4.1-raspi"
	fi
	
	
cat >> "${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}/qmake.conf" << EOF
	
QMAKE_INCDIR    += ${UV_sysroot_dir}/include \\
                   ${UV_sysroot_dir}/include/glib-2.0 \\
                   ${UV_sysroot_dir}/lib/glib-2.0/include \\
                   ${UV_sysroot_dir}/include/dbus-1.0 \\
                   ${UV_sysroot_dir}/lib/dbus-1.0/include \\
                   ${UV_sysroot_dir}/include/gstreamer-0.10 \\
                   ${UV_sysroot_dir}/include/freetype \\
                   ${UV_sysroot_dir}/include/libxml2 \\
				   ${UV_sysroot_dir}/include/directfb \\
				   ${UV_sysroot_dir}/include/gstreamer-0.10 \\
				   ${UV_sysroot_dir}/include/libpng16

QMAKE_LIBDIR    += ${UV_sysroot_dir}/lib

QMAKE_LIBS      += -lpthread -lrt -ldl -lresolv -lz -lxcb -lXau -lxcb-util

load(qt_config)
EOF

	GV_args=(
		"-v"
		"-xplatform ${GV_source_dir}/${GV_dir_name}/qtbase/mkspecs/${device}"
		"-opensource"
		"-confirm-license"
		"-release"
		"-make libs"
		"-prefix ${LV_qt_dir}"
		"-no-cups"
		"-no-largefile"
		"-no-sql-ibase"
		"-no-sql-psql"
		"-no-sql-mysql"
		"-no-sql-odbc"
		"-no-sse2"
		"-no-ssse3"
		"-no-compile-examples"
		"-optimized-qmake"
		"-no-nis"
		"-force-pkg-config"
	)
	
	FU_build_configure
	FU_build_make
	FU_build_install
	FU_build_finishinstall
	
	# link pkg config files
	ln -s $LV_qt_dir/lib/pkgconfig/* $PKG_CONFIG_PATH/
	
	cd $GV_base_dir

	export CFLAGS=$TMP_CFLAGS
	export CXXFLAGS=$TMP_CXXFLAGS
	export LDFLAGS=$TMP_LDFLAGS

fi
