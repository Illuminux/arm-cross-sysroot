#!/bin/bash

GV_url="http://www.wavpack.com/wavpack-4.70.0.tar.bz2"

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

FU_tools_get_names_from_url
FU_tools_installed "${GV_name}.pc"

if [ $? == 1 ]; then
	FU_file_get_download
	FU_file_extract_tar
	FU_build	
	
cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
Requires:
prefix=${UV_sysroot_dir}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: ${GV_name}
Description: wavpack library
Version: ${GV_version}
Requires:
Conflicts:
Libs: -L$\{libdir} -lwavpack
Libs.private: -lm
Cflags: -I$\{includedir}

EOF
fi