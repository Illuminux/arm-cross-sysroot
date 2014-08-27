#!/bin/bash

TITLE="gst - GStreamer open source multimedia framework"

build_gst(){

	build_libxml2
	build_glib

	cd $WORKING_DIR/src
	
	NAME=gstreamer-0.11.2
	ARCHIV=$NAME.tar.bz2
	URL=http://gstreamer.freedesktop.org/src/gstreamer/$ARCHIV
	
	# Download if archiv not exist 
	if ! [[ -f "$WORKING_DIR/src/$ARCHIV" || -d "$WORKING_DIR/src/$NAME" ]]; then
		echo "Download $ARCHIV"
		curl -O $URL
	fi
	
	# Extract archiv is dir not exists
	if ! [ -d "$WORKING_DIR/src/$NAME" ]; then
	
		echo -n "Extracting $NAME... "
		tar xjf $ARCHIV
		echo "done"

	fi
	
	cd $WORKING_DIR/src/$NAME
	
	echo -n "Configure $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.configured" ]; then

		LDFLAGS="-L$PREFIX/lib -lffi" \
		CFLAGS="-I$PREFIX/include -I$PREFIX/lib/libffi-3.1/include" \
		GLIB_CFLAGS="-I$PREFIX/include/glib-2.0 -I$PREFIX/lib/glib-2.0/include" \
		GLIB_LIBS="-L$PREFIX/lib -lglib-2.0 -lgmodule-2.0 -lgobject-2.0 -lgthread-2.0" \
		GIO_CFLAGS="-I$PREFIX/include/gio-unix-2.0" \
		GIO_LIBS="-L$PREFIX/lib -lgio-2.0" \
		./configure --prefix=$PREFIX --host=$HOST \
			--disable-nls --disable-valgrind --disable-examples --disable-tests \
			--disable-failing-tests --disable-largefile --disable-parse \
			--disable-check >/dev/null 2>&1 || exit 1
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
