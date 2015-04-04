#!/bin/bash

GV_url="http://sourceforge.net/projects/opencvlibrary/files/latest/download/opencv-2.4.10"
GV_sha1="0b185f5e332d5feef91722a6ed68c36a6d33909e"

DEPEND=(
	"cryptodev"
)

GV_args=()

FU_tools_get_names_from_url
FU_tools_installed "${LV_formula%;*}.pc"

if [ $? == 1 ]; then
	
	if [ -d "${GV_source_dir}/${GV_dir_name}/build" ]; then 
		rm -rf "${GV_source_dir}/${GV_dir_name}/build"
	fi
	
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	
	cd "${GV_source_dir}/${GV_dir_name}/build"
	
	
	if [ "${UV_board}" == "beaglebone" ]; then 
		LV_ENABLE_NEON="ON"
	else
		LV_ENABLE_NEON="OFF"
	fi
	
	echo -n "Configure ${GV_name}... "
	cmake \
		-DCMAKE_SYSTEM_NAME="Linux" \
		-DCMAKE_SYSTEM_VERSION=1 \
		-DCMAKE_SYSTEM_PROCESSOR="arm" \
		-DCMAKE_C_COMPILER="${UV_target}-gcc" \
		-DCMAKE_CXX_COMPILER="${UV_target}-g++" \
		-DCMAKE_EXE_LINKER_FLAGS="-Wl,-z,nocopyreloc" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi" \
		-DCMAKE_C_FLAGS="$CFLAGS -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi" \
		-DCMAKE_SHARED_LINKER_FLAGS="-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now" \
		-DCMAKE_MODULE_LINKER_FLAGS="-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now" \
		-DCMAKE_EXE_LINKER_FLAGS="-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now" \
		-DCMAKE_SYSTEM_LIBRARY_PATH="${UV_sysroot_dir}/lib" \
		-DCMAKE_LIBRARY_PATH="${UV_sysroot_dir}/lib" \
		-DCMAKE_SYSTEM_INCLUDE_PATH="${UV_sysroot_dir}/include" \
		-DCMAKE_INCLUDE_PATH="${UV_sysroot_dir}/include" \
	    -DZLIB_LIBRARY="${UV_sysroot_dir}/lib/libz.so" \
	    -DPNG_LIBRARY="${UV_sysroot_dir}/lib/libpng12.so" \
		-DJPEG_LIBRARY="${UV_sysroot_dir}/lib/libjpeg.so" \
		-DTIFF_LIBRARY="${UV_sysroot_dir}/lib/libtiff.so" \
		-DWITH_QT=ON \
		-DWITH_OpenEXR=OFF \
		-DENABLE_NEON=$LV_ENABLE_NEON \
		-DCMAKE_FIND_ROOT_PATH="${CMAKE_FIND_ROOT_PATH} $UV_toolchain_dir" \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_INSTALL_PREFIX="$UV_sysroot_dir" \
		-DZLIB_INCLUDE_DIR="${UV_sysroot_dir}/include" \
	    -DZLIB_LIBRARY="${UV_sysroot_dir}/lib/libz.so" \
		-DCMAKE_RELEASE_TYPE=Release \
		"${GV_source_dir}/${GV_dir_name}"
	
	make -j4 \
		CC="${UV_target}-gcc" \
		CXX="${UV_target}-g++" \
		AR="${UV_target}-ar" \
		RANLIB="${UV_target}-ranlib"
	
	FU_build_finishinstall
fi

unset LV_pkg_name
