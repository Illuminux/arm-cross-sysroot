#!/bin/bash

URL="http://ftp.gnome.org/pub/gnome/sources/glib/2.40/glib-2.40.0.tar.xz"

DEPEND=(
	"zlib"
	"libffi"
)

ARGS=(
	"--host=${HOST}"
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
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
	"glib_cv_stack_grows=no"
	"glib_cv_uscore=yes"
	"ac_cv_func_posix_getpwuid_r=yes"
	"ac_cv_func_posix_getgrgid_r=yes"
)

get_names_from_url
installed "${NAME}-2.0.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
