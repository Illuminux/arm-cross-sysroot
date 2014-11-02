#!/bin/bash

system_require() {

	# required software

	REQUIRES=(
		"git"
		"gettext"
		"curl"
		"autogen"
		"autoconf"
		"libtool"
		"bison"
		"xsltproc"
		"cmake"
	)
	
	if [ $(uname -s) = "Darwin" ]; then 
		if ! hash "brew" 2>/dev/null; then
			echo "For running this script on Mac OS X you have to install Homebrew."
			echo "You can download Homebrew from: http://brew.sh"
		fi
	fi

	# sudo apt-get install python-xcbgen

	for REQUIRE in "${REQUIRES[@]}"
	do
		if ! hash $REQUIRE 2>/dev/null; then
			echo "The application $REQUIRE is not installed!"
			echo "You can install $REQUIRE as follows"
			
			if [ $(uname -s) = "Darwin" ]; then 
				echo "brew install $REQUIRE"
				echo
				echo "Some packages are not linked. In order to link, type:"
				echo "brew link $REQUIRE --force"
			else
				echo "sudo apt-get install $REQUIRE"
			fi
			exit
		fi
	done 
	
	
	# OS X needs
	#  - glib
	
	# required packages
	if [ $(uname -s) = "Linux" ]; then 
		if ! [ -d "/usr/lib/python2.7/dist-packages/xcbgen" ]; then
			echo "The package python-xcbgen is not installed!"
			echo "You can install python-xcbgen as follows"
			echo "sudo apt-get install python-xcbgen"
			exit
		fi
	fi
	
	if [ $(uname -s) = "Darwin" ]; then
		if ! [ -d "/usr/local/Cellar/glib" ]; then
			echo "The package glib is not installed!"
			echo "brew install glib"
			exit
		fi
	fi
}
