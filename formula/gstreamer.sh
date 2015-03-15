#!/bin/bash

GV_url="http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.gz"

DEPEND=(
	"glib"
	"libxml2"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-nls"
	"--disable-examples"
	"--disable-tests"
	"--disable-loadsave"
	"--disable-largefile"
	"--disable-docbook"
	"--disable-gtk-doc"
	"--disable-parse"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "gstreamer-0.10.pc"

if [ $? == 1 ]; then
	
	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal" "${UV_sysroot_dir}/bin/glib-genmarshal_bak"
	fi
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread"
	
	FU_get_download
	FU_extract_tar
	FU_build

	unset LIBS
	export LIBS=$TMP_LIBS

	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal_bak" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal_bak" "${UV_sysroot_dir}/bin/glib-genmarshal"
	fi
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/gstreamer-0.10"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
export LDFLAGS="${LDFLAGS} -L${UV_sysroot_dir}/lib/gstreamer-0.10"
