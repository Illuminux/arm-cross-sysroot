#!/bin/bash

GV_url="http://dbus.freedesktop.org/releases/dbus/dbus-1.8.0.tar.gz"

DEPEND=(
	"expat"
	"glib"
)

GV_args=(		
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--host=${GV_host}"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
	"--without-x"
)


get_names_from_url
installed "${GV_name}-1.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -lgio-2.0 -lgobject-2.0 -lffi -lgmodule-2.0 -ldl -lglib-2.0 -lz -lresolv -lrt"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/dbus-1.0 -I${UV_sysroot_dir}/lib/dbus-1.0/include"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS