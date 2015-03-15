#!/bin/bash
#
# ARM Cross Sysroot is a script bundle to cross-compile libraries on a 
# host computer for an ARM target. This git repo contains just scripts 
# to build the libraries for an ARM target. It does not contains any 
# of the the source. They will be downloaded during the build process.
#
# Copyright (C) 2014  Knut Welzel
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 

clear

##
## Working directory of the Script
##
GV_base_dir=$(pwd)

## Build start time
GV_total_start=$(date +%s)

##
## check if config.cfg exists or exit
##
if ! [ -f "${GV_base_dir}/config.cfg" ]; then
	
	echo "Error: The configuration file could not be found!"
	echo 
	echo "Rename or copy the file config.cfg.sample into config.cfg"
	echo "and customize the variable according to your system settings."
	echo "  $ cp config.cfg.sample config.cfg"
	echo "  $ nano config.cfg"
	echo 
	exit
fi


##
## Includ library and configuration files 
##
source "${GV_base_dir}/config.cfg"
source "${GV_base_dir}/include/settings.cfg"
source "${GV_base_dir}/include/system.sh"
source "${GV_base_dir}/include/tools.sh"
source "${GV_base_dir}/include/files.sh"
source "${GV_base_dir}/include/build.sh"


##
## Chcke if a sysroot olready exists (Mac only)
##
if [ -f "${UV_sysroot_dir}/.directory" ]; then
	
	while true; do
		echo "The root directory already exists."
		echo "This is because the script was executed before."
		echo "If the image is not deleted or changed since the last run, you can press continued."
		echo "Otherwise, the entire root must be recreated."
		echo
		read -p "Continue or abbort the script [C/a]: " LV_key
		
		LV_key=${Ca:-C}
		
		case $LV_key in
			
			[Cc]* ) 
				rm -rf ${UV_sysroot_dir}
				break;;
			
			[Aa]* ) clear; exit 0;;
			
		esac
	done
	
	unset LV_key
fi

##
## Parse the comandline arguments 
##
parse_arguments $@


echo "Start to build an advanced sysroot for ${UV_board}."
echo


##
## test required software for host
##
system_require

##
## Mac OS X needs an case sensitiv diskimage
##
if [ $(uname -s) = "Darwin" ]; then 
	create_source_image
	create_sysroot_image
else
	# test access rights for building the sysroot
	access_rights
fi


##
## Build and Version information
##
if ! [ -f "${UV_sysroot_dir}/buildinfo.txt" ]; then
	touch "${UV_sysroot_dir}/buildinfo.txt"
else
	echo >> "${UV_sysroot_dir}/buildinfo.txt"
	echo "*** Rebuild ***" >> "${UV_sysroot_dir}/buildinfo.txt"
	echo >> "${UV_sysroot_dir}/buildinfo.txt"
fi
cat >> "${UV_sysroot_dir}/buildinfo.txt" << EOF
Script Version: 1.0.3
Script Date:	20 Nov 2014
Build Date:		$(date)
Build User:		$(whoami)
Build Machine:	$(uname -v)

Packages:
EOF


##
## Make sure that we are still in working directory 
##
cd $GV_base_dir


##
## Execute all formulas. The scripts have to be processed in this sequence!
##
source "${GV_base_dir}/formula/zlib.sh"
source "${GV_base_dir}/formula/bzip2.sh"
source "${GV_base_dir}/formula/liblzma.sh"
source "${GV_base_dir}/formula/libffi.sh"
source "${GV_base_dir}/formula/expat.sh"
source "${GV_base_dir}/formula/tslib.sh"
source "${GV_base_dir}/formula/glib.sh"
source "${GV_base_dir}/formula/dbus.sh"
source "${GV_base_dir}/formula/gsl.sh"
source "${GV_base_dir}/formula/gmp.sh"
source "${GV_base_dir}/formula/mpfr.sh"
source "${GV_base_dir}/formula/ncurses.sh"
source "${GV_base_dir}/formula/readline.sh"
source "${GV_base_dir}/formula/sqlite.sh"
source "${GV_base_dir}/formula/cryptodev.sh"
source "${GV_base_dir}/formula/openssl.sh"
source "${GV_base_dir}/formula/libssh2.sh"
source "${GV_base_dir}/formula/curl.sh"
source "${GV_base_dir}/formula/libxml2.sh"
source "${GV_base_dir}/formula/gstreamer.sh"
source "${GV_base_dir}/formula/libjpeg.sh"
source "${GV_base_dir}/formula/libpng.sh"
source "${GV_base_dir}/formula/libtiff.sh"
source "${GV_base_dir}/formula/lcms2.sh"
source "${GV_base_dir}/formula/libraw.sh"
source "${GV_base_dir}/formula/alsa-lib.sh"
source "${GV_base_dir}/formula/libogg.sh"
source "${GV_base_dir}/formula/libvorbis.sh"
source "${GV_base_dir}/formula/libtheora.sh"
source "${GV_base_dir}/formula/libvisual.sh"
source "${GV_base_dir}/formula/liborc.sh"
source "${GV_base_dir}/formula/pixman.sh"
source "${GV_base_dir}/formula/util-macros.sh"
source "${GV_base_dir}/formula/xtrans.sh"
source "${GV_base_dir}/formula/xproto.sh"
source "${GV_base_dir}/formula/xextproto.sh"
source "${GV_base_dir}/formula/inputproto.sh"
source "${GV_base_dir}/formula/xcb-proto.sh"
source "${GV_base_dir}/formula/libpthread-stubs.sh"
source "${GV_base_dir}/formula/libXau.sh"
source "${GV_base_dir}/formula/libgpg-error.sh"
source "${GV_base_dir}/formula/libgcrypt.sh"
source "${GV_base_dir}/formula/libxslt.sh"
source "${GV_base_dir}/formula/libxcb.sh"
source "${GV_base_dir}/formula/videoproto.sh"
source "${GV_base_dir}/formula/kbproto.sh"
source "${GV_base_dir}/formula/freetype.sh"
source "${GV_base_dir}/formula/fontconfig.sh"
source "${GV_base_dir}/formula/libX11.sh"
source "${GV_base_dir}/formula/libXext.sh"
source "${GV_base_dir}/formula/libXv.sh"
source "${GV_base_dir}/formula/directfb.sh"
source "${GV_base_dir}/formula/qt.sh"
source "${GV_base_dir}/formula/qjson.sh"
source "${GV_base_dir}/formula/cairo.sh"
source "${GV_base_dir}/formula/gst-plugins-base.sh"
source "${GV_base_dir}/formula/wavpack.sh"

if [ $(uname -s) = "Linux" ]; then
	source "${GV_base_dir}/formula/taglib.sh"
fi

source "${GV_base_dir}/formula/libx264.sh"
source "${GV_base_dir}/formula/libav.sh"
source "${GV_base_dir}/formula/gst-plugins-good.sh"
source "${GV_base_dir}/formula/i2c-tools.sh"
source "${GV_base_dir}/formula/bluez.sh"
source "${GV_base_dir}/formula/libmodbus.sh"
source "${GV_base_dir}/formula/liblqr.sh"
source "${GV_base_dir}/formula/imagemagick.sh"
source "${GV_base_dir}/formula/libconfig.sh"
# cmake sucks
#if ! [ "${UV_board}" == "raspi" ]; then
#	source "${GV_base_dir}/formula/opencv.sh"
#fi
source "${GV_base_dir}/formula/libusb.sh"

if [ "${UV_board}" == "raspi" ]; then
	source "${GV_base_dir}/formula/wiringpi.sh"
fi

if [ "${UV_board}" == "beaglebone" ]; then
	source "${GV_base_dir}/formula/blacklib.sh"
fi

source "${GV_base_dir}/formula/json-glib.sh"
source "${GV_base_dir}/formula/libsoup.sh"

echo "Cleanup build directory."
rm -rf "${GV_base_dir}/tmp"

if [ $(uname -s) = "Darwin" ]; then 
	echo -n "Unmount source image... " 
	hdiutil detach $GV_source_dir >/dev/null 2>&1 || exit 1
	rm -rf "${GV_base_dir}/sources.sparseimage"
	echo "done"
	
	echo -n "Move sysroot into a local directory... " 
	mkdir -p "${UV_sysroot_dir}_tmp"
	cp -RP "${UV_sysroot_dir}/lib" "${UV_sysroot_dir}_tmp/lib"
	cp -RP "${UV_sysroot_dir}/include" "${UV_sysroot_dir}_tmp/include"
	cp "${UV_sysroot_dir}/buildinfo.txt" "${UV_sysroot_dir}_tmp/buildinfo.txt"
	echo "done"
	
	echo -n "Unmount sysroot image... " 
	hdiutil detach $UV_sysroot_dir >/dev/null 2>&1 || exit 1
	mv "${UV_sysroot_dir}_tmp" "${UV_sysroot_dir}"
	touch "${UV_sysroot_dir}/.directory"
	echo "done"
	echo 
	echo "Caution: Do not delete or remove the sysroot.sparseimage!"
	echo "         It will be needed for rebuilding the sysroot!"
	echo
else
	rm -rf "${GV_base_dir}/src"
fi

TOTAL_END=`date +%s`
TOTAL_TIME=`expr $TOTAL_END - $GV_total_start`

if [ $(uname -s) = "Darwin" ]; then 
	AWK=gawk
else
	AWK=awk
fi

echo "" >> "${UV_sysroot_dir}/buildinfo.txt"
echo -n "Sysroot successfully build in " >> "${UV_sysroot_dir}/buildinfo.txt"
echo $TOTAL_TIME | $AWK '{print strftime("%H:%M:%S", $1,1)}' >> "${UV_sysroot_dir}/buildinfo.txt"
echo -n "Sysroot successfully build in " 
echo $TOTAL_TIME | $AWK '{print strftime("%H:%M:%S", $1,1)}'
