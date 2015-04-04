#!/bin/bash

GV_url="http://cairographics.org/releases/cairo-1.12.2.tar.xz"
GV_sha1="bc2ee50690575f16dab33af42a2e6cdc6451e3f9"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	GV_args=(
		"--host=${GV_host}"
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--enable-xml"
		"--enable-xlib-xcb"
		"--enable-directfb"
		"--disable-largefile"
		#"--enable-qt"
	)
	
	TMP_CPPFLAGS=$CPPFLAGS
	TMP_CFLAGS=$CFLAGS
	
#	export LIBS="-lpthread -lm"
		
	if [ "${UV_board}" == "beaglebone" ]; then 
		
		export CFLAGS="${CFLAGS} -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard -pipe -fstack-protector"
		export CPPFLAGS="${CPPFLAGS} -O3 -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=hard -D_FORTIFY_SOURCE=2"
		
	elif [ "${UV_board}" == "raspi" ]; then
		
		export CFLAGS="${CFLAGS} -O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard -pipe -fstack-protector"
		export CPPFLAGS="${CPPFLAGS} --O3 -march=armv6j -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard -D_FORTIFY_SOURCE=2"
		
	elif [ "${UV_board}" == "hardfloat" ]; then
		
		export CFLAGS="${CFLAGS} -O3 -mfloat-abi=hard -pipe -fstack-protector"
		export CPPFLAGS="${CPPFLAGS} -O3 -mfloat-abi=hard -D_FORTIFY_SOURCE=2"
		
	else
		
		export CFLAGS="${CFLAGS} -O3 -pipe -fstack-protector"
		export CPPFLAGS="${CPPFLAGS} -O3 -D_FORTIFY_SOURCE=2"		
	fi
	
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	cd "${UV_sysroot_dir}/lib"
	ln -s libcairo.so.2.11200.2 libcairo.so.2
	ln -s libcairo.so.2.11200.2 libcairo.so
	cd $GV_base_dir
	
#	cd "${GV_source_dir}/${GV_dir_name}"
#	echo -n "Patch ${GV_name}... "		
#	patch -p1 < "${GV_base_dir}/patches/cairo.patch" >$GV_log_file 2>&1
#	FU_tools_is_error "$?"
#	cd $GV_base_dir
	
	export CPPFLAGS=$TMP_CPPFLAGS
	export CFLAGS=$TMP_CFLAGS
#	unset LIBS
	
fi
