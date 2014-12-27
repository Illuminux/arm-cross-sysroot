# arm-cross-sysroot

ARM Cross Sysroot is a script bundle to cross-compile libraries on a host computer for an ARM target. This git repo contains just scripts to build the libraries for an ARM target. It does not contains any of the the source. They will be downloaded during the build process.

## Usage

By default clone the script into your home development directory.

`$ git clone https://github.com/Illuminux/arm-cross-sysroot.git`

Change into the *arm-cross-sysroot* directory and copy/rename the file *[config.cfg.sample](config.cfg.sample)* to *config.cfg*:

`$ mv config.cfg.sample config.cfg`

Open *config.cfg* with an editor of your choice and and customize it according to your system.

- `SYSROOT_DIR` Directory in which the sysroot should be installed.
- `DOWNLOAD_DIR` Directory in which the downloads are to be loaded
- `TOOLCHAIN_DIR` Directory where the toolchain is located (exclude bin directory)
- `TARGET` Target architecture/Tollchain prefix  

To build the cross sysroot just run the following command:

`$ ./sysroot-build.sh`

## Dependencies

### Linux:

#### Host Packages installation:

- `$ sudo apt-get install build-essentials git gettext curl autogen autoconf libtool bison xsltproc cmake python-xcbgen`

#### GCC ARM Cross ToolChain:

- [arm-linux-gnueabihf](http://releases.linaro.org/14.07/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.07_linux.tar.bz2)<br>Hardfloat - Linaro Toolchain Binaries 4.9 (BeagleBone etc.)
- gcc-linaro-arm-linux-gnueabihf-raspbian (Raspberry PI): `$ git clone https://github.com/raspberrypi/tools.git`
- [arm-none-linux-gnueabi](https://sourcery.mentor.com/GNUToolchain/package12813/public/arm-none-linux-gnueabi/arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2):<br>Softfloat CodeSourcery Toolchain Binaries (QNAP etc.)
	
### Mac OS X

#### Host Packages installation:
- Xcode Command Line Tools:<br>
`$ xcode-select --install`
- Homebrew:<br>
`$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)`
- Homebrew packages:<br>
`$ brew install gettext curl autogen autoconf libtool bison xsltproc cmake glib`

#### GCC ARM Cross ToolChain:

- [arm-linux-gnueabihf](http://www.welzels.de/blog/download/gcc-linaro-arm-linux-gnueabihf-2014.05_mac.zip)<br>Hardfloat - Based on Linaro crosstool-NG (BeagleBone etc.)
- [arm-linux-gnueabihf-raspbian](http://www.welzels.de/blog/download/gcc-linaro-arm-linux-gnueabihf-raspbian-2014.05_mac.zip)<br> Hardfloat - Based on Linaro crosstool-NG (Raspberry PI)
- [arm-linux-gnueabi](http://www.carlson-minot.com/downloads/arm-2014.05-29-arm-none-linux-gnueabi.osx.intelx86.bin.pkg)<br>Softfloat - Carlson-Minot Based on CodeSourcery - (QNAP etc.)

## Supported libraries:

- **Image Libraries:**
	- libjpeg - Independent JPEG Group's JPEG runtime library 
	- limping - PNG library
	- libtiff - Tag Image File Format library
	- libraw - raw image decoder library
	- liblcms2 - Little CMS 2 color management library development headers
	- imagemagick - image manipulation library 

- **Audio and Video Libraries:**
	- gstreamer - pipeline-based multimedia framework 
	- gst-plugins-base - GStreamer libraries from the "base" set 
	- gst-plugins-good - GStreamer development files for libraries from the "good" set 
	- alsa - Advanced Linux Sound Architecture
	- liboog - Ogg bitstream library
	- libvorbis - Vorbis General Audio Compression Codec 
	- libtheora - Theora Video Compression Codec
	- libvisual - Audio visualization framework
	- wavpack - Audio codec (lossy and lossless) encoder and decoder 
	- lib - Open source audio and video processing tools
	- taglib - Library for reading and editing the meta-data of audio formats <sup>**1.**</sup>

- **Compression Libraries:**
	- zlib - Compressing File-I/O Library
	- bzip2 - High-quality block-sorting file compressor
	- liblzma - XZ-format compression library

- **Markup Language Libraries:**
	- expat - XML parsing C library
	- libxml2 - GNOME XML library
	- json-c - JSON manipulation library
	- json-glib - GLib JSON manipulation library

- **Hardware Libraries:**
	- tslib - Abstraction layer for touchscreen
	- i2c-tools - Heterogeneous set of I2C tools for Linux
	- bluez - Bluetooth protocol stack library
	- libusb - userspace USB programming library
	- wiringPi - GPIO Interface library for the Raspberry Pi <sup>**2.**</sup>

- **Communication:**
	- libmodbus - Library for the Modbus protocol
	- curl - Command line tool for transferring data with URL syntax

- **Mathematic and Scientific Libraries:**
	- gsl - GNU Scientific Library
	- gmp - Multi precision arithmetic library developers tools
	- mpfr - Multiple precision floating-point computation developers tools
	- <del>opencv - Open Source Computer Vision Library</del><br>*(no idea why, but can only compile on my iMac and not on my Mac Book Pro.* 

- **Database:**
	- sqlite - Database management system libraries

- **Framework and System Libraries:**
	- Qt - Qt 4 development files and development programs for host
	- glib - GLib development library
	- dbus - Simple interprocess messaging system
	- libffi - Foreign function interface library
	- ncurses - text-based user interfaces library
	- readline - GNU readline and history libraries
	- cryptodev - Access to Linux kernel cryptographic drivers
	- openssl - Secure Sockets Layer toolkit
	- liborc - Library of Optimized Inner Loops Runtime Compiler
	- freetype - FreeType 2 font engine
	- fontconfig - Generic font configuration library 
	- cairo - The Cairo 2D vector graphics library
	- liblqr - Converts plain array images into multi-size representation
	- libssh2 - SSH2 client-side library
	- libdirectfb - Direct frame buffer graphics library
	- libconfig - Configuration File Library

- **X11 Libraries:**
	- libX11 - X11 client-side library
	- libXext - X11 miscellaneous extensions library
	- pixman - pixel-manipulation library for X
	- xtrans - X transport library
	- xproto
	- xextproto
	- inputproto 
	- xcb-proto - X C Binding
	- libpthread-stubs - pthread stubs not provided by native libc
	- libXau - X11 authorisation library
	- libgpg-error - Library for common error values and messages in GnuPG components
	- libgcrypt - LGPL Crypto library
	- libxslt - XSLT 1.0 processing library
	- libxcb - X C Binding
	- videoproto - X11 Video extension wire protocol
	- kbproto - X11 XKB extension wire protocol
	- libXv - X11 Video extension library

<hr>
<small>
<sup>**1.)**</sup> Linux only.<br>
<sup>**2.)**</sup> Raspberry Pi only.
</small>

