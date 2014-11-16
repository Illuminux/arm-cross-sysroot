#!/bin/bash

URL="http://dl.lm-sensors.org/i2c-tools/releases/i2c-tools-3.1.1.tar.bz2"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
		
	get_download
	extract_tar
	
	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	echo -n "  Make ${NAME}... "
	make \
		CC="${TARGET}-gcc" \
		AR="${TARGET}-ar" \
		RANLIB="${TARGET}-ranlib" \
		prefix="${PREFIX}" >$LOG_FILE 2>&1
	is_error "$?"
	
	echo -n "  Install ${NAME}... "
	make install \
		CC="${TARGET}-gcc" \
		AR="${TARGET}-ar" \
		RANLIB="${TARGET}-ranlib" \
		prefix="${PREFIX}" >$LOG_FILE 2>&1
	is_error "$?"
	
	cd $BASE_DIR
	
	rm -rf "${SYSROOT_DIR}/sbin"
	rm -rf "${SYSROOT_DIR}/share"

cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include/linux

Name: ${NAME}
Description: I2C Tools libraries
Version: ${VERSION}

Requires:
Libs: -L\${libdir}
Cflags: -I\${includedir}
EOF
fi
