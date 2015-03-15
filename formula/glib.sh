#!/bin/bash

GV_url="http://ftp.gnome.org/pub/gnome/sources/glib/2.40/glib-2.40.0.tar.xz"

DEPEND=(
	"zlib"
	"libffi"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--disable-gtk-doc"
	"--disable-gtk-doc-html"
	"--disable-gtk-doc-pdf"
	"--disable-man"
	"--disable-largefile"
	"--disable-fam"
	"--disable-libelf"
	"--disable-always-build-tests"
	"--disable-installed-tests"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
	"glib_cv_stack_grows=no"
	"glib_cv_uscore=yes"
	"ac_cv_func_posix_getpwuid_r=yes"
	"ac_cv_func_posix_getgrgid_r=yes"
)

get_names_from_url
installed "${GV_name}-2.0.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/glib-2.0 -I${UV_sysroot_dir}/lib/glib-2.0/include"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CPPFLAGS
