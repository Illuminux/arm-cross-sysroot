#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://gstreamer.freedesktop.org/src/orc/orc-0.4.22.tar.xz"
	GV_sha1="c50cf2f2a9a7e4ab400fd79f706e831ace1936bc"
else
	GV_url="http://gstreamer.freedesktop.org/src/orc/orc-0.4.16.tar.gz"
	GV_sha1="b67131881e7834b0c820bfba468f668100fb2e91"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "orc-0.4.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/orc-0.4"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
