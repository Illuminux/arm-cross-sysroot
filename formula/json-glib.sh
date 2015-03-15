#!/bin/bash

GV_url="ftp://ftp.gnome.org/pub/gnome/sources/json-glib//0.14/json-glib-0.14.2.tar.xz"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--sharedstatedir=${GV_base_dir}/tmp/com"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
	"--disable-glibtest"
	"--disable-gtk-doc"
	"--disable-nls"
)

get_names_from_url
installed "json-glib-1.0.pc"

if [ $? == 1 ]; then
	
	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal" "${UV_sysroot_dir}/bin/glib-genmarshal_bak"
	fi
	
	get_download
	extract_tar
	build

	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal_bak" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal_bak" "${UV_sysroot_dir}/bin/glib-genmarshal"
	fi

fi
