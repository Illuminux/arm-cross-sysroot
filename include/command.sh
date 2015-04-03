#!/bin/bash

do_cd() {

	cd $1 >$GV_log_file 2>&1 \
		|| FU_tools_error
}


do_mkdir() {

	mkdir -p $1 2>&1 \
		|| FU_tools_error
}


do_cpdir() {
	
	cp -rf $1 $2 >$GV_log_file 2>&1 \
		|| FU_tools_error
}