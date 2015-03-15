#!/bin/bash

system_require() {

	# required software

	LV_requires=(
		"git"
		"gettext"
		"curl"
		"autogen"
		"autoconf"
		"automake"
		"libtool"
		"bison"
		"xsltproc"
		"cmake"
		"gawk"
	)
	
	if [ $(uname -s) = "Darwin" ]; then 
		
		#LV_requires+=("gawk")
		
		if ! hash "brew" 2>/dev/null; then
			echo "For running this script on Mac OS X you have to install Homebrew."
			echo "You can download Homebrew from: http://brew.sh"
			echo
			exit 1
		fi
	fi
	
	LV_missing_requires=()
	
	# Serach for required programs 
	for VAR_require in "${LV_requires[@]}"
	do
		if ! hash $VAR_require 2>/dev/null; then
			LV_missing_requires+=($VAR_require)
		fi
	done 
	
	# search for required packages
	if [ $(uname -s) = "Linux" ]; then 
		
		# Glib developer package 
		if ! [ -f "/usr/bin/glib-genmarshal" ]; then 
			LV_missing_requires+=("libglib2.0-dev")
		fi
		
		# python-xcbgen
		if ! [ -d "/usr/lib/python2.7/dist-packages/xcbgen" ]; then
			LV_missing_requires+=("python-xcbgen")
		fi
		
		# Intltool
		if ! [ -f "/usr/bin/intltoolize" ]; then
			LV_missing_requires+=("intltool")
		fi
		
	elif [ $(uname -s) = "Darwin" ]; then
		
		# Glib
		if ! [ -d "/usr/local/Cellar/glib" ]; then
			LV_missing_requires+=("glib")
		fi
	
		# Intltool - the binary is called "intltoolize"
		if ! [ -d "/usr/local/Cellar/intltool" ]; then
			LV_missing_requires+=("intltool")
		fi
	fi
	
	
	if [ ${#LV_missing_requires[@]} -ne 0 ]; then
		
		echo "Some required applications are not installed!"
		echo "You can install them as follows:"
		
		if [ $(uname -s) = "Darwin" ]; then 
			echo "  $ brew install ${LV_missing_requires[@]}"
			echo
			echo "Some packages are not linked. In order to link, type:"
			echo "  $ brew link [GV_name] --force"
		else
			echo "  $ sudo apt-get install ${LV_missing_requires[@]}"
		fi
		
		echo
		exit 1
	fi
	
	# Check if cross compiler is avalible
	if ! [ -f "${UV_toolchain_dir}/bin/${UV_target}-gcc" ]; then
		
		echo "Error: Cross compiler not found!"
		echo "Please check your configuration file."
		echo 
		exit 1
	fi
	
	unset LV_requires 
	unset LV_missing_requires
}
