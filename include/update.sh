#!/bin/bash

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