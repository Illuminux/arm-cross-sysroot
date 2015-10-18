#!/bin/bash

#GV_url="http://download.sourceforge.net/libpng/libpng-1.6.16.tar.xz"
#GV_sha1="31855a8438ae795d249574b0da15b34eb0922e13"

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://download.sourceforge.net/libpng/libpng-1.2.50.tar.xz"
	GV_sha1="3ac9c32fc08804d4a1858cb5d02c6d0fb55ede37"
else
	GV_url="http://download.sourceforge.net/libpng/libpng-1.2.49.tar.xz"
	GV_sha1="0984ab46fbfa5a34ca8d98958eebe5fb52b22294"	
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "libpng12.pc"

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

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/libpng16"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
