#!/bin/bash

TITLE="glib - GLib Toolkit"

build_glib(){

	build_zlib
	build_libffi

	cd $WORKING_DIR/src
	
	NAME=glib-2.40.0
	ARCHIV=$NAME.tar.xz
	URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.40/$ARCHIV
	
	# Download if archiv not exist 
	if ! [[ -f "$WORKING_DIR/src/$ARCHIV" || -d "$WORKING_DIR/src/$NAME" ]]; then
		echo "Download $ARCHIV"
		curl -O $URL
	fi
	
	# Extract archiv is dir not exists
	if ! [ -d "$WORKING_DIR/src/$NAME" ]; then
	
		echo -n "Extracting $NAME... "
		tar xJf $ARCHIV
		echo "done"

	fi
	
	cd $WORKING_DIR/src/$NAME
	
	echo -n "Configure $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.configured" ]; then

		ZLIB_CFLAGS="-I$PREFIX/include" \
		ZLIB_LIBS="-L$PREFIX/lib -lz" \
		LIBFFI_CFLAGS="-I$PREFIX/lib/libffi-3.1/include" \
		LIBFFI_LIBS="-L$PREFIX/lib -lffi" \
		./configure --prefix=$PREFIX --host=$HOST \
			--with-libiconv=no \
			--without-pcre \
			--enable-gtk-doc-html=no \
			--enable-xattr=no \
			--disable-largefile \
			glib_cv_stack_grows=yes \
			glib_cv_uscore=yes \
			ac_cv_func_posix_getpwuid_r=no \
			ac_cv_func_posix_getgrgid_r=no >/dev/null 2>&1 || exit 1

		touch $WORKING_DIR/src/$NAME/.configured
		echo "done"
		
	else 
		echo "skipped"
	fi
	
	echo -n "Make $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.made" ]; then
		
		make >/dev/null 2>&1 || exit 1
		touch $WORKING_DIR/src/$NAME/.made
		echo "done"
		
	else 
		echo "skipped"
	fi
	
	echo -n "Install $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.installed" ]; then
		
		make install >/dev/null 2>&1 || exit 1
		touch $WORKING_DIR/src/$NAME/.installed
		echo "done"
		
	else 
		echo "skipped"
	fi	
	
	cd $WORKING_DIR
}
