#!/bin/bash

GV_url="ftp://xmlsoft.org/libxml2/libxslt-1.1.27.tar.gz"
GV_sha1="f8072177f1ffe1b9bb8759a9e3e6349e1eac1f66"

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
		"--with-crypto"
		"--without-python"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	echo -n "Patch ${GV_name}... "
	patch "${GV_source_dir}/${GV_dir_name}/configure" \
		< "${GV_base_dir}/patches/libxslt.patch" >$GV_log_file 2>&1
	FU_tools_is_error "patch"

	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
