#!/bin/bash

# CAUTION:
# If you change a link location do not change the version number!
# The version is dependent on the distribution. New is not always better!
if [ "${UV_dist}" == "jessie" ]; then
	GV_url="http://www.kernel.org/pub/linux/bluetooth/bluez-5.23.tar.xz"
	GV_sha1="0e378976175b08a19b1232f2af2e83cebee572bd"
else
	GV_url="http://www.kernel.org/pub/linux/bluetooth/bluez-4.99.tar.xz"
	GV_sha1="3d2e240618b7cc4ab16aeafcae749bf42ac0d8d3"
fi

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
