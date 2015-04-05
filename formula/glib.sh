#!/bin/bash

GV_url="http://ftp.gnome.org/pub/gnome/sources/glib/2.40/glib-2.40.0.tar.xz"
GV_sha1="44e1442ed4d1bf3fa89138965deb35afc1335a65"

GV_depend=(
	"zlib"
	"libffi"
)

FU_tools_get_names_from_url
FU_tools_installed "glib-2.0.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-gtk-doc"
		"--disable-gtk-doc-html"
		"--disable-gtk-doc-pdf"
		"--disable-largefile"
		"--disable-fam"
		"--disable-libelf"
		"--disable-always-build-tests"
		"--disable-installed-tests"
		"glib_cv_stack_grows=no"
		"glib_cv_uscore=yes"
		"ac_cv_func_posix_getpwuid_r=yes"
		"ac_cv_func_posix_getgrgid_r=yes"
	)
	
	FU_file_get_download
	FU_file_extract_tar
	
	FU_build_configure
	FU_build_make	
	FU_build_install "install-strip"

	executables=(
		"gapplication"
		"gdbus-codegen"
		"glib-compile-resources"
		"glib-genmarshal"
		"glib-mkenums"
		"gresource"
		"gtester"
		"gdbus"
		"gio-querymodules"
		"glib-compile-schemas"
		"glib-gettextize"
		"gobject-query"
		"gsettings"
	)
	
	for executable in ${executables[@]}; do 
		
		mv -f "${GV_prefix}/bin/$executable" \
			"${GV_prefix}/bin/${GV_host}-$executable"
	done
	
	FU_build_finishinstall
fi

export CFLAGS="${CFLAGS} -I${UV_sysroot_dir}/include/glib-2.0 -I${UV_sysroot_dir}/lib/glib-2.0/include"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS