#!/bin/bash



FU_system_require_darwin() {
	
	# Check for Homebrew
	if ! hash "brew" 2>/dev/null; then
		echo "For running this script on Mac OS X you have to install Homebrew."
		echo "You can download Homebrew from: http://brew.sh"
		echo
		FU_tools_exit
	fi
	
	
	# Serach if the required packages are installed. This packages are all auto 
	# linked. If a packet is not found it will be installed automatically.
	
	for require in "${LV_requires[@]}"
	do
		echo -n "Checking for '$require'... "
		if [ $(brew list | grep -c $require) = 0 ]; then
			brew install $require
			echo "no"
		else 
			echo "yes"
		fi
	done
	
	##Todo: link some force
}


FU_system_require() {

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
		"cmake"
		"gawk"
		"glib"
		"intltool"
	)

	
	# search for required packages
	if [ $GV_build_os = "Linux" ]; then 
		exit
		
	elif [ $GV_build_os = "Darwin" ]; then
		
		FU_system_require_darwin
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

FU_system_require_linux() {
	
	exit
}
