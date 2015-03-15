#!/bin/bash

if ! [ "${UV_board}" == "raspi" ]; then
	return
fi

GV_url="git://git.drogon.net/wiringPi"

DEPEND=()

GV_args=()

get_names_from_url
installed "wiringPi.pc"

if [ $? == 1 ]; then
	
	GV_dir_name=${GV_dir_name%.*}
	GV_name=$GV_dir_name
	
	if ! [ -d "$UV_download_dir" ]; then
		echo -n "  Create Download dir... "
		mkdir -p $UV_download_dir >$GV_log_file 2>&1
		is_error "$?"
		echo "done"
	fi
	
	cd $UV_download_dir
	
	echo -n "Download ${GV_name}... "
	if ! [ -d "${UV_download_dir}/${GV_dir_name}" ]; then
		git clone $GV_url 2>&1
		is_error "$?"
	else
		echo "alredy loaded"
	fi
	
	if ! [ -d "$GV_source_dir" ]; then
		echo -n "Create source dir... "
		mkdir -p $GV_source_dir >$GV_log_file 2>&1
		is_error "$?"
	fi
	
	echo -n "Copy ${GV_name}... "
	if [ -d "${GV_source_dir}/${GV_dir_name}" ]; then
		rm -rf "${GV_source_dir}/${GV_dir_name}"
	fi
	cp -rf "${UV_download_dir}/${GV_dir_name}" "${GV_source_dir}/${GV_dir_name}" >$GV_log_file 2>&1
	is_error "$?"
	rm -rf "${GV_source_dir}/${GV_dir_name}/.git"
	
	
	cd "${GV_source_dir}/${GV_dir_name}"
	
	# remove sudo from install file
	sed -e 's/sudo //g' build > build.sh
	
	MAKEFILES=($(find . -name Makefile))
	
	for entry in ${MAKEFILES[*]}
	do
		cp $entry "${entry}.ori"
		sed -e 's/gcc/arm-linux-gnueabihf-gcc/g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\/local//g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's,/usr,'"$UV_sysroot_dir"',g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@ldconfig//g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@cp gpio/#\@cp gpio/g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@chown/#\@chown/g' "${entry}.ori" > $entry
		cp $entry "${entry}.ori"
		sed -e 's/\@chmod/#\@chmod/g' "${entry}.ori" > $entry
		
		if [ "${entry}" ==  "./devLib/Makefile" ]; then
			cp $entry "${entry}.ori"
			sed -e 's,INCLUDE	= -I.,'"INCLUDE	= -I. -I$UV_sysroot_dir/include"',g' "${entry}.ori" > $entry
		fi
		
		
		rm -f "${entry}.ori"
	done
	
	echo -n "Build and Install ${GV_name}... "
	chmod +x build.sh
	./build.sh >$GV_log_file 2>&1
	is_error "$?"
	
	cd $GV_base_dir
	
	build_finishinstall
	
cat > "${UV_sysroot_dir}/lib/pkgconfig/${GV_name}.pc" << EOF
prefix=${GV_prefix}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: ${GV_name}
Description: GPIO Interface library for the Raspberry Pi
Version: 

Requires:
Libs: -L\${libdir} -L\${sharedlibdir} -lpthread
Cflags: -I\${includedir}
EOF
fi
