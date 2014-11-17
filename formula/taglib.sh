#!/bin/bash

URL="http://ktown.kde.org/~wheeler/files/src/taglib-1.7.2.tar.gz"

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
	cmake \
		-DCMAKE_C_COMPILER="${TOOLCHAIN_BIN_DIR}/${TARGET}-gcc" \
		-DCMAKE_CXX_COMPILER="${TOOLCHAIN_BIN_DIR}/${TARGET}-g++" \
		-DCMAKE_FIND_ROOT_PATH="${TOOLCHAIN_BIN_DIR}/.." \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_INSTALL_PREFIX=$SYSROOT_DIR \
		-DLLVM_DEFAULT_TARGET_TRIPLE=${TARGET} \
		-DLLVM_TARGET_ARCH=ARM \
		-DCMAKE_RELEASE_TYPE=Release >$LOG_FILE 2>&1

	make \
		CC="${TARGET}-gcc" \
		CXX="${TARGET}-g++" \
		AR="${TARGET}-ar" \
		RANLIB="${TARGET}-ranlib" >>$LOG_FILE 2>&1
	is_error "$?"
	
	echo -n "  Install ${NAME}... "
	make install >$LOG_FILE 2>&1
	is_error "$?"

	cd ${BASE_DIR}

	build_finishinstall
fi
