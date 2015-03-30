#!/bin/bash

GV_url="https://gmplib.org/download/gmp/gmp-5.0.5.tar.bz2"
GV_sha1="12a662456033e21aed3e318aef4177f4000afe3b"

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
		"--enable-assert"
		"--enable-alloca"
		"--enable-cxx"
		"--enable-fft"
		"--enable-mpbsd"
		"--enable-fat"
	)
		
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	
	cd "${UV_sysroot_dir}/${GV_host}/include"
	mv -f *mp.* "${UV_sysroot_dir}/include" >/dev/null
	
	cd $GV_base_dir
	rm -rf "${UV_sysroot_dir}/${GV_host}/include" >/dev/null
	
	FU_build_pkg_file "-lgmp"
	
fi
