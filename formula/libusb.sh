#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="https://github.com/libusb/libusb/archive/v1.0.19.tar.gz"
	GV_sha1="7ca6043f87126bef57eed6026306edb302043e9b"
else
	GV_url="https://github.com/libusb/libusb/archive/v1.0.11.tar.gz"
	GV_sha1="2cf0fb3e8d85438777b3ee636f937f782f9c74ce"
fi

GV_depend=()

FU_tools_get_names_from_url

if [ "${UV_dist}" == "jessie" ]; then
	GV_dir_name="libusb-1.0.19"
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
else
	GV_dir_name="libusb-1.0.11"
	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}	
fi

FU_tools_installed "libusb-1.0.pc"

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
		"--disable-udev"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_autogen
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
