#!/bin/bash

system_require() {

	# required software

	REQUIRES=(
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
	)
	
	if [ $(uname -s) = "Darwin" ]; then 
		
		REQUIRES+=("gawk")
		
		if ! hash "brew" 2>/dev/null; then
			echo "For running this script on Mac OS X you have to install Homebrew."
			echo "You can download Homebrew from: http://brew.sh"
			echo
			exit 1
		fi
	fi
	
	MISSING_REQUIRES=()
	
	# Serach for required programs 
	for REQUIRE in "${REQUIRES[@]}"
	do
		if ! hash $REQUIRE 2>/dev/null; then
			MISSING_REQUIRES+=($REQUIRE)
		fi
	done 
	
	# search for required packages
	if [ $(uname -s) = "Linux" ]; then 
		
		# python-xcbgen
		if ! [ -d "/usr/lib/python2.7/dist-packages/xcbgen" ]; then
			MISSING_REQUIRES+=("python-xcbgen")
		fi
		
	elif [ $(uname -s) = "Darwin" ]; then
		
		# Glib
		if ! [ -d "/usr/local/Cellar/glib" ]; then
			MISSING_REQUIRES+=("glib")
		fi
	
		# Intltool - the binary is called "intltoolize"
		if ! [ -d "/usr/local/Cellar/intltool" ]; then
			MISSING_REQUIRES+=("intltool")
		fi
	fi
	
	
	if [ ${#MISSING_REQUIRES[@]} -ne 0 ]; then
		
		echo "Some required applications are not installed!"
		echo "You can install them as follows:"
		
		if [ $(uname -s) = "Darwin" ]; then 
			echo "  $ brew install ${MISSING_REQUIRES[@]}"
			echo
			echo "Some packages are not linked. In order to link, type:"
			echo "  $ brew link [NAME] --force"
		else
			echo "  $ sudo apt-get install ${MISSING_REQUIRES[@]}"
		fi
		
		echo
		exit 1
	fi
	
	# Check if cross compiler is avalible
	if ! [ -f "${TOOLCHAIN_DIR}/bin/${TARGET}-gcc" ]; then
		
		echo "Error: Cross compiler not found!"
		echo "Please check your configuration file."
		echo 
		exit 1
	fi
}
