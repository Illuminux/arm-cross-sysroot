#!/bin/bash
#
# arm-cross-build-script - Script Bundle to cross-compile of some libraries
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

WORKING_DIR=$(pwd)

source settings.cfg

export PATH=$CFG_CC_PATH:$PATH
export PREFIX=$CFG_BUILD_DIR
export TARGET=$CFG_TARGET
export HOST=$CFG_HOST
cd $WORKING_DIR

clear

# Check for source dir
if ! [ -d "$WORKING_DIR/src" ]; then
	mkdir $WORKING_DIR/src
fi

# Check for build dir
if ! [ -d "$CFG_BUILD_DIR" ]; then
	mkdir $CFG_BUILD_DIR
fi


# Check for cross compiler is in CFG_CC_PATH
if ! [ -d "${CFG_CC_PATH}" ]; then
	echo
	echo "*** Failure **** Cross Compiler not found!"
	echo "Please add your Cross Compiler path in 'settings.cfg'."
	echo 
fi

# Check for cross compiler works


# scan script dir for scripts
cd $WORKING_DIR/scripts
for i in *.sh; do 
	source $WORKING_DIR/scripts/$i
#	echo "   $TITLE"
done
cd $WORKING_DIR


# Print build menu
echo "What would you like to be built:"
echo "   1.  zlib Compressing File-I/O Library"
echo "   2.  libffi Foreign Function Interface Library"
echo "   3.  libxml2 XML C parser"
echo "   4.  GLib Toolkit"
echo "   5.  GStreamer open source multimedia framework"
#echo "   6.  GStreamer Base Plugin"
echo "   0.  Abort this script"

while true; do
	read -p "Enter a number above: " SELECTION
	SELECTION=${SELECTION:-0}
	case $SELECTION in
		[0]* ) exit 0;;
		[1]* ) build_zlib; break;;
		[2]* ) build_libffi; break;;
		[3]* ) build_libxml2; break;;
		[4]* ) build_glib; break;;
		[5]* ) build_gst; break;;
#		[6]* ) build_gstPluginsBase; break;;
		   * ) echo "Not a valid selection!";;
	esac
done


