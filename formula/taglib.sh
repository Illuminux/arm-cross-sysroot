#!/bin/bash

# Linux only
if ! [ $GV_build_os = "Linux" ]; then
	return
fi

GV_url="http://ktown.kde.org/~wheeler/files/src/taglib-1.7.2.tar.gz"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	echo -n "  Make ${GV_name}... "
	cmake \
		-DCMAKE_C_COMPILER="${UV_toolchain_dir}/bin/${UV_target}-gcc" \
		-DCMAKE_CXX_COMPILER="${UV_toolchain_dir}/bin/${UV_target}-g++" \
		-DCMAKE_FIND_ROOT_PATH="${UV_toolchain_dir}/bin/.." \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_INSTALL_GV_prefix=$UV_sysroot_dir \
		-DLLVM_DEFAULT_UV_target_TRIPLE=${UV_target} \
		-DLLVM_UV_target_ARCH=ARM \
		-DCMAKE_RELEASE_TYPE=Release >$GV_log_file 2>&1

	make -j4 \
		CC="${UV_target}-gcc" \
		CXX="${UV_target}-g++" \
		AR="${UV_target}-ar" \
		RANLIB="${UV_target}-ranlib" >>$GV_log_file 2>&1
	FU_is_error "$?"
	
	echo -n "  Install ${GV_name}... "
	make install >$GV_log_file 2>&1
	FU_is_error "$?"

	cd ${GV_base_dir}

	FU_build_finishinstall
fi
