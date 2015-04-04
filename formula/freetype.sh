#!/bin/bash

GV_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.4.9.tar.bz2"
GV_sha1="5cb80ab9d369c4e81a2221bcf45adcea2c996b9b"

GV_depend=(
	"zlib"
)

FU_tools_get_names_from_url
GV_version="14.1.8"
FU_tools_installed "freetype2.pc"

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
	
	rm -f "${GV_source_dir}/${GV_dir_name}config.mk"
	
	FU_build_make
	FU_build_install
	
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/freetype2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
