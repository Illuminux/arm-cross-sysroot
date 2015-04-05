#!/bin/bash

GV_url="http://www.kernel.org/pub/linux/bluetooth/bluez-5.18.tar.xz"
GV_sha1="5d5121b7c4afba5b4b55c1e1db2ef5d77a362a43"

GV_depend=(
	"glib"
	"dbus"
	"readline"
	"libusb"
)

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend
	
	export LIBS="-lrt -lpthread -lresolv -lncurses -lreadline"

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--enable-threads"
		"--enable-library"
		"--disable-udev"
		"--disable-cups"
		"--disable-obex"
		"--disable-systemd"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure	
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
