#!/bin/bash

URL="http://ftp.gnome.org/pub/GNOME/sources/pango/1.30/pango-1.30.1.tar.xz"

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--disable-gtk-doc"
	"--disable-gtk-doc-html"
	"--disable-gtk-doc-pdf"
	"--disable-man"
	"--disable-doc-cross-references"
	"--with-x"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then

	get_download
	extract_tar
	build

	unset CAIRO_CFLAGS
	unset CAIRO_LIBS
fi
