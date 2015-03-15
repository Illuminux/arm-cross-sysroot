#!/bin/bash

return

GV_url="https://github.com/Itseez/opencv.git"

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
FU_installed "opencv.pc"

if [ $? == 1 ]; then
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	
	if ! [ -d "$UV_download_dir" ]; then
		echo -n "  Create Download dir... "
		mkdir -p $UV_download_dir >$GV_log_file 2>&1
		FU_is_error "$?"
		echo "done"
	fi
	
	cd $UV_download_dir
	
	echo -n "  Download ${GV_name}... "
	if ! [ -d "${UV_download_dir}/${GV_dir_name}" ]; then
		git clone $GV_url 2>&1
		FU_is_error "$?"
	else
		echo "alredy loaded"
	fi
	
	if ! [ -d "$GV_source_dir" ]; then
		echo -n "  Create source dir... "
		mkdir -p $GV_source_dir >$GV_log_file 2>&1
		FU_is_error "$?"
	fi
	
	echo -n "  Copy ${GV_name}... "
	if [ -d "${GV_source_dir}/${GV_dir_name}" ]; then
		rm -rf "${GV_source_dir}/${GV_dir_name}"
	fi
	cp -rf "${UV_download_dir}/${GV_dir_name}" "${GV_source_dir}/${GV_dir_name}" >$GV_log_file 2>&1
	FU_is_error "$?"
	rm -rf "${GV_source_dir}/${GV_dir_name}/.git"
	
	GCC_CROSS_COMPILER_GV_version=$($UV_target-gcc -dumpversion)
	
cat > "${GV_source_dir}/${GV_dir_name}/platforms/linux/${UV_target}.toolchain.cmake" << EOF
set(CMAKE_SYSTEM_GV_name Linux)
set(CMAKE_SYSTEM_GV_version 1)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(GCC_COMPILER_GV_version "${GCC_CROSS_COMPILER_GV_version}" CACHE STRING "GCC Compiler version")

set(CMAKE_INSTALL_GV_prefix $UV_sysroot_dir)

set(CMAKE_C_COMPILER    $UV_target-gcc)
set(CMAKE_CXX_COMPILER  $UV_target-g++)
set(ARM_LINUX_SYSROOT $UV_toolchain_dir CACHE PATH "ARM cross compilation system root")

set(CMAKE_CXX_FLAGS           ""                    CACHE STRING "c++ flags")
set(CMAKE_C_FLAGS             ""                    CACHE STRING "c flags")
set(CMAKE_SHARED_LINKER_FLAGS ""                    CACHE STRING "shared linker flags")
set(CMAKE_MODULE_LINKER_FLAGS ""                    CACHE STRING "module linker flags")
set(CMAKE_EXE_LINKER_FLAGS    "-Wl,-z,nocopyreloc"  CACHE STRING "executable linker flags")

set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi")
set(CMAKE_C_FLAGS   "\${CMAKE_C_FLAGS} -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi")

set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now \${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now \${CMAKE_MODULE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS    "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now \${CMAKE_EXE_LINKER_FLAGS}")

if(USE_NEON)
  message(WARNING "You use obsolete variable USE_NEON to enable NEON instruction set. Use -DENABLE_NEON=ON instead." )
  set(ENABLE_NEON TRUE)
elseif(USE_VFPV3)
  message(WARNING "You use obsolete variable USE_VFPV3 to enable VFPV3 instruction set. Use -DENABLE_VFPV3=ON instead." )
  set(ENABLE_VFPV3 TRUE)
endif()

set(CMAKE_FIND_ROOT_PATH \${CMAKE_FIND_ROOT_PATH} \${ARM_LINUX_SYSROOT})

if(EXISTS \${CUDA_TOOLKIT_ROOT_DIR})
    set(CMAKE_FIND_ROOT_PATH \${CMAKE_FIND_ROOT_PATH} ${CUDA_TOOLKIT_ROOT_DIR})
endif()

set( CMAKE_SKIP_RPATH TRUE CACHE BOOL "If set, runtime paths are not added when using shared libraries." )
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)

# macro to find programs on the host OS
macro( find_host_program )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 if( CMAKE_GV_host_WIN32 )
  SET( WIN32 1 )
  SET( UNIX )
 elseif( CMAKE_GV_host_APPLE )
  SET( APPLE 1 )
  SET( UNIX )
 endif()
 find_program( \${ARGN} )
 SET( WIN32 )
 SET( APPLE )
 SET( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endmacro()

# macro to find packages on the host OS
macro( find_host_package )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 if( CMAKE_GV_host_WIN32 )
  SET( WIN32 1 )
  SET( UNIX )
 elseif( CMAKE_GV_host_APPLE )
  SET( APPLE 1 )
  SET( UNIX )
 endif()
 find_package( \${ARGN} )
 SET( WIN32 )
 SET( APPLE )
 SET( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endmacro()
EOF
	
	echo -n "  Configure ${GV_name}... "
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	cd "${GV_source_dir}/${GV_dir_name}/build"
	cmake \
		-DCMAKE_TOOLCHAIN_FILE="${GV_source_dir}/${GV_dir_name}/platforms/linux/${UV_target}.toolchain.cmake" \
			"${GV_source_dir}/${GV_dir_name}" >$GV_log_file 2>&1
	FU_is_error "$?"
	
	
	echo -n "  Make ${GV_name}... "
	make -j4 >$GV_log_file 2>&1
	FU_is_error "$?"
	
	echo -n "  Install ${GV_name}... "
	make install >$GV_log_file 2>&1
	FU_is_error "$?"
	
	cd $GV_base_dir
	
	FU_build_finishinstall
fi
