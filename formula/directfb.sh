#!/bin/bash

URL="http://directfb.org/downloads/Core/DirectFB-1.2/DirectFB-1.2.10.tar.gz"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--sbindir==${BASE_DIR}/tmp/sbin"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--enable-zlibu"
	"--disable-voodoo"
	"--disable-mmx"
	"--disable-sse"
	"--disable-png"
)

get_names_from_url
installed "directfb.pc"

if [ $? == 1 ]; then
	
	TMP_LDFLAGS=$LDFLAGS
	export LDFLAGS="${LDFLAGS} -L${SYSROOT_DIR}/lib/ts"
	
	get_download
	extract_tar
	
	echo -n "Patch ${NAME}... "
	patch "${SOURCE_DIR}/${DIR_NAME}/gfxdrivers/davinci/davinci_c64x.c" \
		< "${BASE_DIR}/patches/directfb_davinci.patch" >$LOG_FILE 2>&1
	is_error "$?"
	
	build
	
	unset LDFLAGS
	export LDFLAGS=$TMP_LDFLAGS
fi
