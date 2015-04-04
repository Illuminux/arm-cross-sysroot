#!/bin/bash

do_cd() {

	cd $1 >$GV_log_file 2>&1 \
		|| FU_tools_error
}


do_mkdir() {
	
	local dir=$1
	
	if ! [ -d $dir ]; then
		mkdir -p $dir 2>&1 || FU_tools_error
	fi
}


do_cpdir() {
	
	cp -rf $1 $2 >$GV_log_file 2>&1 \
		|| FU_tools_error
}