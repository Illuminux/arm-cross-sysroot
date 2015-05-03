#!/bin/bash


$SED -i 's/BASE_DIR/GV_base_dir/g' "${GV_base_dir}/config.cfg"

##
## Updaet old config.cfg
##
if [ -z "$UV_sysroot_dir" ]; then
	UV_sysroot_dir=$SYSROOT_DIR
	$SED -i 's/SYSROOT_DIR/UV_sysroot_dir/g' "${GV_base_dir}/config.cfg"
fi

if [ -z "$UV_download_dir" ]; then
	UV_download_dir=$DOWNLOAD_DIR
	$SED -i 's/DOWNLOAD_DIR/UV_download_dir/g' "${GV_base_dir}/config.cfg"
fi

if [ -z "$UV_toolchain_dir" ]; then
	UV_toolchain_dir=$TOOLCHAIN_DIR
	$SED -i 's/TOOLCHAIN_DIR/UV_toolchain_dir/g' "${GV_base_dir}/config.cfg"
fi

if [ -z "$UV_target" ]; then
	UV_target=$TARGET
	$SED -i 's/TARGET/UV_target/g' "${GV_base_dir}/config.cfg"
fi

if [ -z "$UV_board" ]; then
	UV_board=$BOARD
	$SED -i 's/BOARD/UV_board/g' "${GV_base_dir}/config.cfg"
fi

if [ -z "$UV_qt_5" ]; then 
	
	echo "" >> "${GV_base_dir}/config.cfg"
	echo "#" >> "${GV_base_dir}/config.cfg"
	echo "# QT-Setup" >> "${GV_base_dir}/config.cfg"
	echo "#" >> "${GV_base_dir}/config.cfg"
	echo "" >> "${GV_base_dir}/config.cfg"
	echo "# QT install directory for host enviroment" >> "${GV_base_dir}/config.cfg"
	echo "UV_qt_dir=\"\${UV_sysroot_dir}/Qt\"" >> "${GV_base_dir}/config.cfg"
	echo "" >> "${GV_base_dir}/config.cfg"
	echo "# QT Version - set to "true" to install." >> "${GV_base_dir}/config.cfg"
	echo "# Note: It can be installed both versions. But Qt5 is experimentel and can corrupted Qt4 as well."
	echo "# will be installed." >> "${GV_base_dir}/config.cfg"
	echo "UV_qt_4=true" >> "${GV_base_dir}/config.cfg"
	echo "UV_qt_5=false" >> "${GV_base_dir}/config.cfg"
	
	UV_qt_dir="/usr/local"
	UV_qt_4=true
	UV_qt_5=false
fi