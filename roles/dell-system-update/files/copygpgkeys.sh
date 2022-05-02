#!/bin/sh
# vim:tw=0:et:sw=4:ts=4

# The purpose of this script is to copy the Dell Public GPG keys to Linux 
# DSU default install location.

# these two variables are replaced by the perl script 
# with the actual server name and directory.
SERVER="https://linux.dell.com"
# mind the trailing slash here...
GPG_KEY_REPO="/repo/pgp_pubkeys/"
# these are 'eval'-ed to do var replacement later.
GPG_KEY_LOCATION=${SERVER}${GPG_KEY_REPO}
DSU_INSTALL_PATH='/usr/libexec/dell_dup/'

GPG_KEY_NAME[${#GPG_KEY_NAME[*]}]='0x756ba70b1019ced6.asc'
GPG_KEY_NAME[${#GPG_KEY_NAME[*]}]='0x1285491434D8786F.asc'
GPG_KEY_NAME[${#GPG_KEY_NAME[*]}]='0xca77951d23b66a9d.asc'
GPG_KEY_NAME[${#GPG_KEY_NAME[*]}]='0x3CA66B4946770C59.asc'
                                     

##############################################################################
#  Should not need to edit anything below this point
##############################################################################

set +e

copy_gpg_key() {
    eval GPG_KEY_URL=${GPG_KEY_LOCATION}$1
    echo "${1}: Downloading GPG key."
    GPG_FN=$(mktemp /tmp/GPG-KEY-$$-XXXXXX)
    trap "rm -f $GPG_FN" EXIT HUP QUIT TERM
    curl -s -o ${GPG_FN} ${GPG_KEY_URL}
	
	if [ ! -f  ${GPG_FN} ]; then
		echo "                      : GPG key not downloaded. Skipping!"
	fi
	
	if [ ! -f  ${DSU_INSTALL_PATH}$1 ]; then
		echo "                      : Copying GPG key to ${DSU_INSTALL_PATH}."
		cp ${GPG_FN} ${DSU_INSTALL_PATH}$1
	else
		echo "                      : key already exists at ${DSU_INSTALL_PATH}. Skipping!"
	fi
	
    rm -f $GPG_FN
    trap - EXIT HUP QUIT TERM
}

copy_all_gpg_keys() {
    
	if [ ! -d  ${DSU_INSTALL_PATH} ]; then
		echo "${DSU_INSTALL_PATH} doesn't exist. Creating the directory."
		mkdir ${DSU_INSTALL_PATH}
	fi
	
	local i=0
    while [ $i -lt ${#GPG_KEY_NAME[*]} ]; do
        copy_gpg_key ${GPG_KEY_NAME[$i]}
        i=$(( $i + 1 ))
    done
}

set -e
copy_all_gpg_keys

echo "Done!"
exit 0

