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

BASE_DIR=`pwd`

source "${BASE_DIR}/config.cfg"
source "${BASE_DIR}/include/settings.cfg"
source "${BASE_DIR}/include/system.sh"
source "${BASE_DIR}/include/tools.sh"
source "${BASE_DIR}/include/files.sh"
source "${BASE_DIR}/include/build.sh"


# Mac OS X needs an case sensitiv diskimage
if [ $(uname -s) = "Darwin" ]; then 
	create_image
fi

# test access rights for building the sysroot
access_rights

# test required software for host
system_require

# Parse the comandline arguments 
parse_arguments $@

cd $BASE_DIR

source "${BASE_DIR}/formular/zlib.sh"
source "${BASE_DIR}/formular/bzip2.sh"
source "${BASE_DIR}/formular/liblzma.sh"
source "${BASE_DIR}/formular/libffi.sh"
source "${BASE_DIR}/formular/expat.sh"
source "${BASE_DIR}/formular/tslib.sh"
source "${BASE_DIR}/formular/glib.sh"
source "${BASE_DIR}/formular/dbus.sh"
source "${BASE_DIR}/formular/gsl.sh"
source "${BASE_DIR}/formular/gmp.sh"
source "${BASE_DIR}/formular/mpfr.sh"
source "${BASE_DIR}/formular/ncurses.sh"
source "${BASE_DIR}/formular/readline.sh"
source "${BASE_DIR}/formular/sqlite.sh"
source "${BASE_DIR}/formular/cryptodev.sh"
source "${BASE_DIR}/formular/openssl.sh"
source "${BASE_DIR}/formular/libxml2.sh"
source "${BASE_DIR}/formular/gstreamer.sh"
source "${BASE_DIR}/formular/libjpeg.sh"
source "${BASE_DIR}/formular/libpng.sh"
source "${BASE_DIR}/formular/libtiff.sh"
source "${BASE_DIR}/formular/lcms2.sh"
source "${BASE_DIR}/formular/libraw.sh"
source "${BASE_DIR}/formular/alsa-lib.sh"
source "${BASE_DIR}/formular/libogg.sh"
source "${BASE_DIR}/formular/libvorbis.sh"
source "${BASE_DIR}/formular/libtheora.sh"
source "${BASE_DIR}/formular/libvisual.sh"
source "${BASE_DIR}/formular/liborc.sh"
source "${BASE_DIR}/formular/pixman.sh"
source "${BASE_DIR}/formular/util-macros.sh"
source "${BASE_DIR}/formular/xtrans.sh"
source "${BASE_DIR}/formular/xproto.sh"
source "${BASE_DIR}/formular/xextproto.sh"
source "${BASE_DIR}/formular/inputproto.sh"
source "${BASE_DIR}/formular/xcb-proto.sh"
source "${BASE_DIR}/formular/libpthread-stubs.sh"
source "${BASE_DIR}/formular/libXau.sh"
source "${BASE_DIR}/formular/libgpg-error.sh"
source "${BASE_DIR}/formular/libgcrypt.sh"
source "${BASE_DIR}/formular/libxslt.sh"
source "${BASE_DIR}/formular/libxcb.sh"
source "${BASE_DIR}/formular/videoproto.sh"
source "${BASE_DIR}/formular/kbproto.sh"
source "${BASE_DIR}/formular/freetype.sh"
source "${BASE_DIR}/formular/fontconfig.sh"
source "${BASE_DIR}/formular/libX11.sh"
source "${BASE_DIR}/formular/libXext.sh"
source "${BASE_DIR}/formular/libXv.sh"

if [ $(uname -s) = "Linux" ]; then 
	source "${BASE_DIR}/formular/qt.sh"
fi

if [ $(uname -s) = "Linux" ]; then 
	source "${BASE_DIR}/formular/cairo.sh"
fi

source "${BASE_DIR}/formular/gst-plugins-base.sh"
source "${BASE_DIR}/formular/wavpack.sh"
if [ $(uname -s) = "Linux" ]; then 
	#source "${BASE_DIR}/formular/v4l-utils.sh"
	source "${BASE_DIR}/formular/taglib.sh"
fi

source "${BASE_DIR}/formular/gst-plugins-good.sh"
source "${BASE_DIR}/formular/i2c-tools.sh"
source "${BASE_DIR}/formular/bluez.sh"
source "${BASE_DIR}/formular/libmodbus.sh"
source "${BASE_DIR}/formular/liblqr.sh"
source "${BASE_DIR}/formular/imagemagick.sh"

if [ $(uname -s) = "Linux" ]; then 
	source "${BASE_DIR}/formular/opencv.sh"
fi

echo "Cleanup build directory."
rm -rf "${BASE_DIR}/tmp"
rm -rf "${BASE_DIR}/src"

echo "Sysroot successfully build"
