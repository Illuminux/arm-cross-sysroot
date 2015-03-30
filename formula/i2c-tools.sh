#!/bin/bash

GV_url="http://dl.lm-sensors.org/i2c-tools/releases/i2c-tools-3.1.1.tar.bz2"
GV_sha1="05e4e3b34ebc921812e14527936c0fae65729204"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=()
		
	FU_file_get_download
	FU_file_extract_tar
	
	echo -n "Install ${GV_name}... "
	mkdir -p "${UV_sysroot_dir}/include/linux/"
	cp -rf "${GV_source_dir}/${GV_dir_name}/include/linux/i2c-dev.h" \
		"${UV_sysroot_dir}/include/linux/"
		
	FU_tools_is_error 0

	FU_build_finishinstall

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
includedir=\${prefix}/include/linux

Name: ${GV_name}
Description: I2C Tools libraries
Version: ${GV_version}

Requires:
Cflags: -I\${includedir}
EOF
fi
