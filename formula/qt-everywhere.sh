#!/bin/bash

if "${UV_qt_4}"; then
	source "${GV_base_dir}/formula/qt-everywhere4.sh"
fi

if "${UV_qt_5}"; then
	source "${GV_base_dir}/formula/qt-everywhere5.sh"
fi
