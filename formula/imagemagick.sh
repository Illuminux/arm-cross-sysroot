#!/bin/bash

GV_url="http://mirror.checkdomain.de/imagemagick/releases/ImageMagick-6.7.7-10.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-openmp"
	"--disable-opencl"
	"--disable-largefile"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

get_names_from_url
installed "${GV_name}.pc"

if [ $? == 1 ]; then
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread"
	
	get_download
	extract_tar
	build
	
	unset LIBS
	export LIBS=$TMP_LIBS

cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include/ImageMagick

Name: ${GV_name}
Description: ImageMagick library
Version: ${GV_version}

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lMagick++ -lMagickCore -lMagickWand
Cflags: -I\${includedir}
EOF
fi
