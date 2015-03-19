#!/bin/bash

GV_url="http://www.kernel.org/pub/linux/bluetooth/bluez-5.18.tar.xz"

DEPEND=(
	"glib"
	"dbus"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--enable-threads"
	"--enable-library"
	"--disable-udev"
	"--disable-cups"
	"--disable-obex"
	"--disable-systemd"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_tools_get_names_from_url
FU_tools_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -lc -lrt -ldl -lresolv -lncurses"
	
	FU_file_get_download
	FU_file_extract_tar
	FU_build
	
	unset LIBS
	export LIBS=$TMP_LIBS
			
cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: Bluetooth library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lbluetooth
Cflags: -I\${includedir}
EOF
fi
