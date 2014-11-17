#!/bin/bash

URL="http://www.openssl.org/source/openssl-1.0.1j.tar.gz"

DEPEND=(
	"zlib"
	"cryptodev"
)

ARGS=()

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar

	cd "${SOURCE_DIR}/${DIR_NAME}"

	export ARCH="arm"
	export CROSS_COMPILE="${HOST}-"

	echo -n "Configure ${NAME}... "
	./Configure \
		linux-generic32 \
		--prefix=$PREFIX \
		zlib-dynamic \
		shared \
		no-sse2 \
		-DHAVE_CRYPTODEV >$LOG_FILE 2>&1
	is_error "$?"

	build_make
	build_install

	cd $BASE_DIR
	rm -rf "${SYSROOT_DIR}/ssl"
	
	build_finishinstall
fi