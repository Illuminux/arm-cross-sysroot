#!/bin/bash

URL="http://download.gna.org/cryptodev-linux/cryptodev-linux-1.6.tar.gz"

DEPEND=()

ARGS=()

get_names_from_url

echo -n "Build $NAME:"

if ! [ -d "${PREFIX}/include/crypto" ]; then
	
	echo
	
	get_download
	extract_tar
	
	echo -n "  Install ${NAME}... "
	cp -r "${SOURCE_DIR}/${DIR_NAME}/crypto" "${PREFIX}/include/"
	is_error "$?"
	
	cd $BASE_DIR
else
	echo " already installed"
fi
