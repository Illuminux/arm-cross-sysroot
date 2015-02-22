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
BASE_DIR=`pwd`
TOTAL_START=`date +%s`

##
## check if config.cfg exists or exit
##
if ! [ -f "${BASE_DIR}/config.cfg" ]; then
	
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
source "${BASE_DIR}/config.cfg"
source "${BASE_DIR}/include/settings.cfg"
source "${BASE_DIR}/include/system.sh"
source "${BASE_DIR}/include/tools.sh"
source "${BASE_DIR}/include/files.sh"
source "${BASE_DIR}/include/build.sh"


##
## Chcke if a sysroot olready exists (Mac only)
##
if [ -f "${SYSROOT_DIR}/.directory" ]; then
	
	while true; do
		echo "The root directory already exists."
		echo "This is because the script was executed before."
		echo "If the image is not deleted or changed since the last run, you can press continued."
		echo "Otherwise, the entire root must be recreated."
		echo
		read -p "Continue or abbort the script [C/a]: " Ca
		
		Ca=${Ca:-C}
		
		case $Ca in
			
			[Cc]* ) 
				rm -rf ${SYSROOT_DIR}
				break;;
			
			[Aa]* ) clear; exit 0;;
			
		esac
	done
fi

##
## Parse the comandline arguments 
##
parse_arguments $@


echo "Start to build an advanced sysroot for ${BOARD}."
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
if ! [ -f "${SYSROOT_DIR}/buildinfo.txt" ]; then
	touch "${SYSROOT_DIR}/buildinfo.txt"
else
	echo >> "${SYSROOT_DIR}/buildinfo.txt"
	echo "*** Rebuild ***" >> "${SYSROOT_DIR}/buildinfo.txt"
	echo >> "${SYSROOT_DIR}/buildinfo.txt"
fi
cat >> "${SYSROOT_DIR}/buildinfo.txt" << EOF
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
cd $BASE_DIR


##
## Execute all formulas. The scripts have to be processed in this sequence!
##
source "${BASE_DIR}/formula/zlib.sh"
source "${BASE_DIR}/formula/bzip2.sh"
source "${BASE_DIR}/formula/liblzma.sh"
source "${BASE_DIR}/formula/libffi.sh"
source "${BASE_DIR}/formula/expat.sh"
source "${BASE_DIR}/formula/tslib.sh"
source "${BASE_DIR}/formula/glib.sh"
source "${BASE_DIR}/formula/dbus.sh"
source "${BASE_DIR}/formula/gsl.sh"
source "${BASE_DIR}/formula/gmp.sh"
source "${BASE_DIR}/formula/mpfr.sh"
source "${BASE_DIR}/formula/ncurses.sh"
source "${BASE_DIR}/formula/readline.sh"
source "${BASE_DIR}/formula/sqlite.sh"
source "${BASE_DIR}/formula/cryptodev.sh"
source "${BASE_DIR}/formula/openssl.sh"
source "${BASE_DIR}/formula/libssh2.sh"
source "${BASE_DIR}/formula/curl.sh"
source "${BASE_DIR}/formula/libxml2.sh"
source "${BASE_DIR}/formula/gstreamer.sh"
source "${BASE_DIR}/formula/libjpeg.sh"
source "${BASE_DIR}/formula/libpng.sh"
source "${BASE_DIR}/formula/libtiff.sh"
source "${BASE_DIR}/formula/lcms2.sh"
source "${BASE_DIR}/formula/libraw.sh"
source "${BASE_DIR}/formula/alsa-lib.sh"
source "${BASE_DIR}/formula/libogg.sh"
source "${BASE_DIR}/formula/libvorbis.sh"
source "${BASE_DIR}/formula/libtheora.sh"
source "${BASE_DIR}/formula/libvisual.sh"
source "${BASE_DIR}/formula/liborc.sh"
source "${BASE_DIR}/formula/pixman.sh"
source "${BASE_DIR}/formula/util-macros.sh"
source "${BASE_DIR}/formula/xtrans.sh"
source "${BASE_DIR}/formula/xproto.sh"
source "${BASE_DIR}/formula/xextproto.sh"
source "${BASE_DIR}/formula/inputproto.sh"
source "${BASE_DIR}/formula/xcb-proto.sh"
source "${BASE_DIR}/formula/libpthread-stubs.sh"
source "${BASE_DIR}/formula/libXau.sh"
source "${BASE_DIR}/formula/libgpg-error.sh"
source "${BASE_DIR}/formula/libgcrypt.sh"
source "${BASE_DIR}/formula/libxslt.sh"
source "${BASE_DIR}/formula/libxcb.sh"
source "${BASE_DIR}/formula/videoproto.sh"
source "${BASE_DIR}/formula/kbproto.sh"
source "${BASE_DIR}/formula/freetype.sh"
source "${BASE_DIR}/formula/fontconfig.sh"
source "${BASE_DIR}/formula/libX11.sh"
source "${BASE_DIR}/formula/libXext.sh"
source "${BASE_DIR}/formula/libXv.sh"
source "${BASE_DIR}/formula/directfb.sh"
source "${BASE_DIR}/formula/qt.sh"
source "${BASE_DIR}/formula/qjson.sh"
source "${BASE_DIR}/formula/cairo.sh"
source "${BASE_DIR}/formula/gst-plugins-base.sh"
source "${BASE_DIR}/formula/wavpack.sh"

if [ $(uname -s) = "Linux" ]; then
	source "${BASE_DIR}/formula/taglib.sh"
fi

source "${BASE_DIR}/formula/libx264.sh"
source "${BASE_DIR}/formula/libav.sh"
source "${BASE_DIR}/formula/gst-plugins-good.sh"
source "${BASE_DIR}/formula/i2c-tools.sh"
source "${BASE_DIR}/formula/bluez.sh"
source "${BASE_DIR}/formula/libmodbus.sh"
source "${BASE_DIR}/formula/liblqr.sh"
source "${BASE_DIR}/formula/imagemagick.sh"
source "${BASE_DIR}/formula/libconfig.sh"
# cmake sucks
#if ! [ "${BOARD}" == "raspi" ]; then
#	source "${BASE_DIR}/formula/opencv.sh"
#fi
source "${BASE_DIR}/formula/libusb.sh"

if [ "${BOARD}" == "raspi" ]; then
	source "${BASE_DIR}/formula/wiringpi.sh"
fi

if [ "${BOARD}" == "beaglebone" ]; then
	source "${BASE_DIR}/formula/blacklib.sh"
fi

source "${BASE_DIR}/formula/json-glib.sh"
source "${BASE_DIR}/formula/libsoup.sh"

echo "Cleanup build directory."
rm -rf "${BASE_DIR}/tmp"

if [ $(uname -s) = "Darwin" ]; then 
	echo -n "Unmount source image... " 
	hdiutil detach $SOURCE_DIR >/dev/null 2>&1 || exit 1
	rm -rf "${BASE_DIR}/sources.sparseimage"
	echo "done"
	
	echo -n "Move sysroot into a local directory... " 
	mkdir -p "${SYSROOT_DIR}_tmp"
	cp -RP "${SYSROOT_DIR}/lib" "${SYSROOT_DIR}_tmp/lib"
	cp -RP "${SYSROOT_DIR}/include" "${SYSROOT_DIR}_tmp/include"
	cp "${SYSROOT_DIR}/buildinfo.txt" "${SYSROOT_DIR}_tmp/buildinfo.txt"
	echo "done"
	
	echo -n "Unmount sysroot image... " 
	hdiutil detach $SYSROOT_DIR >/dev/null 2>&1 || exit 1
	mv "${SYSROOT_DIR}_tmp" "${SYSROOT_DIR}"
	touch "${SYSROOT_DIR}/.directory"
	echo "done"
	echo 
	echo "Caution: Do not delete or remove the sysroot.sparseimage!"
	echo "         It will be needed for rebuilding the sysroot!"
	echo
else
	rm -rf "${BASE_DIR}/src"
fi

TOTAL_END=`date +%s`
TOTAL_TIME=`expr $TOTAL_END - $TOTAL_START`

if [ $(uname -s) = "Darwin" ]; then 
	AWK=gawk
else
	AWK=awk
fi

echo "" >> "${SYSROOT_DIR}/buildinfo.txt"
echo -n "Sysroot successfully build in " >> "${SYSROOT_DIR}/buildinfo.txt"
echo $TOTAL_TIME | $AWK '{print strftime("%H:%M:%S", $1,1)}' >> "${SYSROOT_DIR}/buildinfo.txt"
echo -n "Sysroot successfully build in " 
echo $TOTAL_TIME | $AWK '{print strftime("%H:%M:%S", $1,1)}'
