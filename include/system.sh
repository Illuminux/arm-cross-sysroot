#!/bin/bash



FU_system_require_darwin() {

	# required software for Mac
	LV_requires=(
		"gettext"
		"gawk"
		"grep"
		"gnu-sed"
		"curl"
		"pkg-config"
		"libtool"
		"intltool"
		"glib"
		"intltool"
		"autogen"
		"autoconf"
		"automake"
		"cmake"
	)
	
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
			echo
			brew install $require
		else 
			echo "yes"
		fi
	done
	
	# link gettext force
	if ! hash gettext 2>/dev/null; then
		brew link gettext --force
	fi
}

FU_system_require_linux() {
	
	# required software for Linux
	LV_requires=(
		"gettext"
		"gawk"
		"grep"
		"sed"
		"curl"
		"pkg-config"
		"libtool"
		"intltool"
		"glib"
		"intltool"
		"autogen"
		"autoconf"
		"automake"
		"cmake"
		"libxml2-dev"
	)
	
	# Serach if the required packages are installed.
	# If a packet is not found it will not be installed automatically.
	for require in "${LV_requires[@]}"
	do
		echo -n "Checking for '$require'... "
		if [ $(dpkg --list | grep -c $require) = 0 ]; then
			echo "no"
			echo 
			echo "Pleas install the $require by typing the following command and run the script again:"
			echo "  sudo apt-get install $require"
			echo 
			exit 1
		else 
			echo "yes"
		fi
	done
}


FU_system_require() {

	echo ${UV_toolchain_dir}
	
	# Check if cross compiler is avalible
	if ! [ -f "${UV_toolchain_dir}/bin/${UV_target}-gcc" ]; then
		
		echo "Error: Cross compiler not found!"
		echo "Please check your configuration file."
		echo 
		exit 1
	fi
	
	# search for required packages
	if [ $GV_build_os = "Linux" ]; then 
		FU_system_require_linux
		
	elif [ $GV_build_os = "Darwin" ]; then
		
		FU_system_require_darwin
	fi
	
	unset LV_requires 
	unset LV_missing_requires
}
