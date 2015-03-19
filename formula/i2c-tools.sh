#!/bin/bash

GV_url="http://dl.lm-sensors.org/i2c-tools/releases/i2c-tools-3.1.1.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_tools_get_names_from_url
FU_tools_installed "${GV_name}.pc"

if [ $? == 1 ]; then
		
	FU_file_get_download
	FU_file_extract_tar
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "Make ${GV_name}... "
	make -j4 \
		CC="${UV_target}-gcc" \
		AR="${UV_target}-ar" \
		RANLIB="${UV_target}-ranlib" \
		prefix="${GV_prefix}" >$GV_log_file 2>&1
	FU_tools_is_error "$?"
	
	echo -n "Install ${GV_name}... "
	make install \
		CC="${UV_target}-gcc" \
		AR="${UV_target}-ar" \
		RANLIB="${UV_target}-ranlib" \
		prefix="${GV_prefix}" >$GV_log_file 2>&1
	FU_tools_is_error "$?"
	
	cd $GV_base_dir
	
	rm -rf "${UV_sysroot_dir}/sbin"
	rm -rf "${UV_sysroot_dir}/share"
	
	FU_build_finishinstall

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include/linux

Name: ${GV_name}
Description: I2C Tools libraries
Version: ${GV_version}

Requires:
Libs: -L\${libdir}
Cflags: -I\${includedir}
EOF
fi
