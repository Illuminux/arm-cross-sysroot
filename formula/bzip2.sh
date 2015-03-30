#!/bin/bash

GV_url="http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
GV_sha1="3f89f861209ce81a6bab1fd1998c0ef311712002"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"
if [ $? == 1 ]; then
	
	FU_tools_check_depend
		
	FU_file_get_download
	FU_file_extract_tar
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Make ${GV_name}... "
	make -f Makefile-libbz2_so \
			CC="${UV_target}-gcc" \
			AR="${UV_target}-ar" \
			RANLIB="${UV_target}-ranlib" >$GV_log_file \
			PREFIX="${UV_sysroot_dir}/${GV_host}" 2>&1
	FU_tools_is_error "$?"

	echo -n "Install ${GV_name}... "
	make install  \
			CC="${UV_target}-gcc" \
			AR="${UV_target}-ar" \
			RANLIB="${UV_target}-ranlib" >$GV_log_file \
			PREFIX="${UV_sysroot_dir}/${GV_host}" 2>&1
	FU_tools_is_error "$?"
	
	cp -av libbz2.so* "${UV_sysroot_dir}/lib" >/dev/null
	
	cd "${UV_sysroot_dir}/${GV_host}/lib"
	mv -f libbz2.* "${UV_sysroot_dir}/lib" >/dev/null
	
	cd "${UV_sysroot_dir}/${GV_host}/include"
	mv -f bzlib.* "${UV_sysroot_dir}/include" >/dev/null
	
	cd $GV_base_dir
	rm -rf "${UV_sysroot_dir}/${GV_host}/lib" >/dev/null
	rm -rf "${UV_sysroot_dir}/${GV_host}/include" >/dev/null

	FU_build_pkg_file "-lbzip2"
	
	FU_build_finishinstall 

fi
