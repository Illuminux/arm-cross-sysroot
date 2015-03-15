#!/bin/bash

GV_url="http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.40/libsoup-2.40.3.tar.xz"

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
	"--disable-tls-check"
	"--without-gnome"
)

get_names_from_url
installed "libsoup-2.4.pc"

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
