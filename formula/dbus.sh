#!/bin/bash

GV_url="http://dbus.freedesktop.org/releases/dbus/dbus-1.8.0.tar.gz"
GV_sha1="d14ab33e92e29fa732cdff69214913832181e737"

GV_depend=(
	"expat"
	"glib"
)

FU_tools_get_names_from_url
FU_tools_installed "dbus-1.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	export LIBS="-lpthread -ldl -lresolv"
	
	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-xml-docs"
		"--disable-doxygen-docs"
		"--without-x"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall	
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/dbus-1.0 -I${UV_sysroot_dir}/lib/dbus-1.0/include"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS

