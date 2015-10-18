#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="ftp://sourceware.org/pub/libffi//libffi-3.1.tar.gz"
	GV_sha1="cb373ef2115ec7c57913b84ca72eee14b10ccdc3"
else
	GV_url="ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz"
	GV_sha1="f5230890dc0be42fb5c58fbf793da253155de106"
fi

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

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
	
	ln -s "${UV_sysroot_dir}/lib/libffi-${GV_version}/include/ffi.h" \
		"${UV_sysroot_dir}/include/"
	ln -s "${UV_sysroot_dir}/lib/libffi-${GV_version}/include/ffitarget.h" \
		"${UV_sysroot_dir}/include/"
	
	$SED -i 's/(libdir)/{libdir}/g' "${UV_sysroot_dir}/lib/pkgconfig/libffi.pc"

	FU_build_finishinstall
fi
