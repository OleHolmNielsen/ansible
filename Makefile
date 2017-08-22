# First-time setup of the SSH authorized_key

default: init_authorized_key.yml
	ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -vv --ask-pass init_authorized_key.yml
