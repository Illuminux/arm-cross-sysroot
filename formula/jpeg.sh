#!/bin/bash

if [ "${UV_dist}" == "jessie" ]; then
	source "${GV_base_dir}/formula/libjpeg62-turbo.sh"
else
	source "${GV_base_dir}/formula/libjpeg8.sh"
fi