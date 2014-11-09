#!/bin/bash

URL="https://www.python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--disable-ipv6"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
#	get_download
#	extract_tar

	TMP_CPPFLAGS=$CPPFLAGS
	TMP_CFLAGS=$CFLAGS
	TMP_CXXFLAGS=$CXXFLAGS

	unset CFLAGS
	unset CPPFLAGS
	unset CXXFLAGS

	cd "${SOURCE_DIR}/${DIR_NAME}"

	curl -O 

	./configure

	make python Parser/pgen

	mv python hostpython
	mv Parser/pgen Parser/hostpgen

	make distclean

	export CPPFLAGS=$TMP_CPPFLAGS
	export CFLAGS=$TMP_CFLAGS
	export CXXFLAGS=$TMP_CXXFLAGS

#	CXX="${HOST}-g++" \
#	CC="${HOST}-gcc" \
#	AR="${HOST}-ar" \
#	RANLIB="${HOST}-ranlib" \
	./configure \
		"--host=${HOST}" \
		"--target=${TARGET}" \ 
		"--prefix=${PREFIX}" \		
		"--disable-ipv6"

	make HOSTPYTHON=./hostpython \
		HOSTPGEN=./Parser/hostpgen \
		BLDSHARED="${HOST}-gcc -shared"

	cd $BASE_DIR

#	build
fi
