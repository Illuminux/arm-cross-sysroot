#!/bin/bash

TITLE="gstPluginsBase - GStreamer Base Plugin"

build_gstPluginsBase(){

	build_gstreamer

	cd $WORKING_DIR/src
	
	NAME=gst-plugins-base-0.11.2
	ARCHIV=$NAME.tar.gz
	URL=http://gstreamer.freedesktop.org/src/gst-plugins-base/$ARCHIV
	
	# Download if archiv not exist 
	if ! [[ -f "$WORKING_DIR/src/$ARCHIV" || -d "$WORKING_DIR/src/$NAME" ]]; then
		echo -n "Download $ARCHIV"
		wget $URL >/dev/null 2>&1 || exit 1
		echo "done"
	fi
	
	# Extract archiv is dir not exists
	if ! [ -d "$WORKING_DIR/src/$NAME" ]; then
	
		echo -n "Extracting $NAME... "
		tar xzf $ARCHIV
		echo "done"

	fi
	
	cd $WORKING_DIR/src/$NAME
	
	echo -n "Configure $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.configured" ]; then

./configure --help
exit		
		PKG_CONFIG="$PREFIX/lib/pkgconfig" \
		LDFLAGS="-L$PREFIX/lib -lffi" \
		CFLAGS="-I$PREFIX/include -I$PREFIX/lib/libffi-3.1/include" \
		GLIB_CFLAGS="-I$PREFIX/include/glib-2.0 -I$PREFIX/lib/glib-2.0/include" \
		GLIB_LIBS="-L$PREFIX/lib -lglib-2.0 -lgmodule-2.0 -lgobject-2.0 -lgthread-2.0" \
		GIO_CFLAGS="-I$PREFIX/include/gio-unix-2.0" \
		GIO_LIBS="-L$PREFIX/lib -lgio-2.0" \
		GST_CFLAGS="-I$PREFIX/include/gstreamer-0.11/gst" \
		GST_LIBS="-L$PREFIX/lib" \
		./configure --prefix=$PREFIX --host=$HOST 

exit
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
