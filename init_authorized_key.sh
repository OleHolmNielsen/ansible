#!/bin/sh

if test $# -ne 1
then
	echo Usage: $0 hostname
	exit 1
fi

DOMAIN=fysik.dtu.dk

# ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --ask-pass init_authorized_key.yml -l $1.$DOMAIN
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --ask-pass init_authorized_key.yml -l $1
