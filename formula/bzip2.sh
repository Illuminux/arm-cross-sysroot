#!/bin/bash

GV_url="http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"

GV_args=()

FU_get_names_from_url
FU_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Make ${GV_name}... "

	make -f Makefile-libbz2_so \
		CC="${UV_target}-gcc" \
		AR="${UV_target}-ar" \
		RANLIB="${UV_target}-ranlib" >$GV_log_file 2>&1
	FU_is_error "$?"

	echo -n "Install ${GV_name}... "

	cp -av libbz2.so* "${UV_sysroot_dir}/lib" >/dev/null

	make install \
		CC="${UV_target}-gcc" \
		AR="${UV_target}-ar" \
		RANLIB="${UV_target}-ranlib" \
		GV_prefix="${UV_sysroot_dir}" >$GV_log_file 2>&1
	FU_is_error "$?"
	
	cd $GV_base_dir
	rm -rf "${UV_sysroot_dir}/man"
	mv "${UV_sysroot_dir}/bin/bunzip2" "${UV_sysroot_dir}/bin/${UV_target}-bunzip2"
	mv "${UV_sysroot_dir}/bin/bzcat" "${UV_sysroot_dir}/bin/${UV_target}-bzcat"
	mv "${UV_sysroot_dir}/bin/bzip2" "${UV_sysroot_dir}/bin/${UV_target}-bzip2"
	mv "${UV_sysroot_dir}/bin/bzip2recover" "${UV_sysroot_dir}/bin/${UV_target}-bzip2recover"
	
	FU_build_finishinstall

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: bz2 compression library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lbz2
Cflags: -I\${includedir}
EOF
fi
