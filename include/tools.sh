#!/bin/bash


is_error() {
	
	if [ "$1" == "0" ]; then
		echo "donne"
	else
		echo "faild"
		cat $LOG_FILE
		echo 
		echo "*** Error in $NAME ***"
		echo 
		exit 1
	fi
}


get_names_from_url() {

	TAR_NAME=${URL##*/}
	get_names_from_dir_name $TAR_NAME
}


get_names_from_dir_name() {
	
	DIR_NAME=${1%.tar.*}
	NAME=${DIR_NAME%-*}
	VERSION=${DIR_NAME##$NAME*-}
	EXTENSION=${TAR_NAME##*.}
}


installed() {
	
	echo -n "Build $NAME:"
	
	if [ -f "$SYSROOT_DIR/lib/pkgconfig/$1" ]; then
		echo " already installed"
		return 0
	elif [ -f "$SYSROOT_DIR/usr/lib/pkgconfig/$1" ]; then
		echo " already installed"
		return 0
	elif [ -f "$SYSROOT_DIR/usr/local/lib/pkgconfig/$1" ]; then
		echo " already installed"
		return 0
	else
		echo
		return 1
	fi
}


must_have_sudo() {

	 echo "Cannot write into directory \"${SYSROOT_DIR}\"."
	 echo "You can run the script by typing \"sudo $0\"."
	 exit 1
}


access_rights() {
	
	# test access rights for building the sysroot
	if ! [ -d ${SYSROOT_DIR} ]; then
		mkdir -p "${SYSROOT_DIR}" >/dev/null 2>&1 \
			|| must_have_sudo
	else
		touch "${SYSROOT_DIR}/access_test" >/dev/null 2>&1 \
			&& rm -f "${SYSROOT_DIR}/access_test" \
			|| must_have_sudo
	fi
}


print_usage() {

	echo "print help"
}


parse_arguments() {
	
	ARGV=($@)

	for arg in "${ARGV[@]}"
	do
		case "$arg" in
			("--configure-show")
				ARG_CONF_SHOW=true;;
			("--configure-help")
				ARG_CONF_HELP=true;;
			("--make-show")
				ARG_MAKE_SHOW=true;;
			("--help")
				print_usage;;
		esac
	done

}
