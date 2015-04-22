#!/bin/bash

if "${UV_qt_5}"; then
	
	# On QT update
	if ! [ -f "${PKG_CONFIG_PATH}/Qt5Core.pc" ]; then 
		
		# Remove QJson pkg config file so that will be build new for QT 5
		if [ -f "${PKG_CONFIG_PATH}/QJson.pc" ]; then 
			rm -f "${PKG_CONFIG_PATH}/QJson.pc"
		fi
	fi
	
	source "${GV_base_dir}/formula/qt-everywhere5.sh"
else
	
	# Install Qt4 only if Qt5 is not installed 
	if [ -f "${PKG_CONFIG_PATH}/Qt5Core.pc" ]; then 
	
		if [ $? == 1 ]; then
			echo "*** failure: QT5 is already installed! A downgrade is not possible!"
		else
			source "${GV_base_dir}/formula/qt-everywhere4.sh"
		fi
	fi
fi