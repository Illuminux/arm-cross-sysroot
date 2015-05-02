#!/bin/bash

##
## Check required software for Mac OS X
##
FU_system_require_darwin() {

	# required software for Mac
	local requires=(
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
	
	# Check for Homebrew package manager 
	echo -n "Checking for 'brew'... "
	if ! hash "brew" 2>/dev/null; then
		echo "faild"
		echo
		echo "  To execute this script on Mac OS X you have to install Homebrew."
		echo "  You can download Homebrew from: http://brew.sh"
		echo
		exit 1
	fi
	
	
	# Serach if the required packages are installed. This packages are all auto 
	# linked. If a packet is not found it will be installed automatically.
	
	for require in "${requires[@]}"
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

##
## Check required software for Linux
##
FU_system_require_linux() {
	
	local missing_requires=()
	
	# required software for Linux
	local requires=(
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
		"xsltproc"
	)
	
	# Serach if the required packages are installed.
	# If a packet is not found it will not be installed automatically becuase 
	# we need root access for that.
	for require in "${requires[@]}"
	do
		echo -n "Checking for '$require'... "
		if [ $(dpkg --list | grep -c $require) = 0 ]; then
			echo "no"
			missing_requires+=($require)
		else 
			echo "yes"
		fi
	done
	
	# Display the missing packages
	if [ ${#missing_requires[@]} -gt 0 ]; then 
		echo 
		echo "*** Some required packages were not found! ***"
		echo "Pleas install the required packages by running the following command and run the script again:"
		echo
		echo "  sudo apt-get install ${missing_requires[*]}"
		echo 
		exit 1
	fi
}

##
## Check cross compiler and required software
##
FU_system_require() {
	
	# Check if cross compiler is avalible
	echo -n "Checking for '${UV_target}-gcc'... "
	if ! [ -f "${UV_toolchain_dir}/bin/${UV_target}-gcc" ]; then
		echo "faild"
		echo 
		echo "*** Error cross compiler not found!       ***"
		echo "*** Please check your configuration file. ***"
		echo 
		exit 1
	else
		echo "yes"
	fi
	
	# search for required packages
	if [ $GV_build_os = "Linux" ]; then 
		FU_system_require_linux
		
	elif [ $GV_build_os = "Darwin" ]; then
		FU_system_require_darwin
	fi
}