#!/bin/bash

URL="https://s3.amazonaws.com/json-c_releases/releases/json-c-0.10.tar.gz"

DEPEND=()

ARGS=(
	"--host=${HOST}"
	"--program-prefix=${TARGET}-"
	"--sbindir=${BASE_DIR}/tmp/sbin"
	"--libexecdir=${BASE_DIR}/tmp/libexec"
	"--sysconfdir=${BASE_DIR}/tmp/etc"
	"--localstatedir=${BASE_DIR}/tmp/var"
	"--datarootdir=${BASE_DIR}/tmp/share"
)

get_names_from_url
installed "json.pc"

if [ $? == 1 ]; then
	get_download
	extract_tar
	build
fi
