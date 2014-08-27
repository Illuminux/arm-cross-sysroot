arm-cross-build-script
======================

Script Bundle to cross-compile of some libraries

Currently supported libraries:
- zlib Compressing File-I/O Library
- libffi Foreign Function Interface Library
- libxml2 XML C parser"
- GLib Toolkit
- GStreamer open source multimedia framework

Dependencies: GCC ARM Cross ToolChain
- Linaro: http://www.linaro.org/downloads/

This git repo contains just scripts to build libraries for ARM devices. 
It doesn't any of the the source, so it will downloaded during the build 
process.

To build a library just run the build script:
`./build.sh`
