#!/bin/bash

URL="http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"

ARGS=()

get_names_from_url
installed "${NAME}.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	
	cd "${SOURCE_DIR}/${DIR_NAME}"
	
	echo -n "Make ${NAME}... "

	make -f Makefile-libbz2_so \
		CC="${TARGET}-gcc" \
		AR="${TARGET}-ar" \
		RANLIB="${TARGET}-ranlib" >$LOG_FILE 2>&1
	is_error "$?"

	echo -n "Install ${NAME}... "

	cp -av libbz2.so* "${SYSROOT_DIR}/lib" >/dev/null

	make install \
		CC="${TARGET}-gcc" \
		AR="${TARGET}-ar" \
		RANLIB="${TARGET}-ranlib" \
		PREFIX="${SYSROOT_DIR}" >$LOG_FILE 2>&1
	is_error "$?"
	
	cd $BASE_DIR
	rm -rf "${SYSROOT_DIR}/man"
	mv "${SYSROOT_DIR}/bin/bunzip2" "${SYSROOT_DIR}/bin/${TARGET}-bunzip2"
	mv "${SYSROOT_DIR}/bin/bzcat" "${SYSROOT_DIR}/bin/${TARGET}-bzcat"
	mv "${SYSROOT_DIR}/bin/bzip2" "${SYSROOT_DIR}/bin/${TARGET}-bzip2"
	mv "${SYSROOT_DIR}/bin/bzip2recover" "${SYSROOT_DIR}/bin/${TARGET}-bzip2recover"
	
	build_finishinstall

cat > "${SYSROOT_DIR}/lib/pkgconfig/${NAME}.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${NAME}
Description: bz2 compression library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lbz2
Cflags: -I\${includedir}
EOF
fi
