#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.5.2.tar.bz2"
	GV_sha1="72731cf405b9f7c0b56d144130a8daafa262b729"
else
	GV_url="http://download.savannah.gnu.org/releases/freetype/freetype-2.4.9.tar.bz2"
	GV_sha1="5cb80ab9d369c4e81a2221bcf45adcea2c996b9b"
fi

GV_depend=(
	"zlib"
)

FU_tools_get_names_from_url
if [ "${UV_dist}" == "jessie" ]; then
	GV_version="17.1.11"
else
	GV_version="14.1.8"
fi
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
	
	export LIBPNG_CFLAGS="${UV_sysroot_dir}/lib/"
	export LIBPNG_LDFLAGS="${UV_sysroot_dir}/include/"
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	
	rm -f "${GV_source_dir}/${GV_dir_name}config.mk"
	
	FU_build_make
	FU_build_install
	FU_build_finishinstall
	
	unset LIBPNG_CFLAGS
	unset LIBPNG_LDFLAGS
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/freetype2"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
