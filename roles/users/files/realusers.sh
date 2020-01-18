#!/bin/sh

# Print the "real" (non-system) usernames from the passwd file.
# The special group file /etc/group.fys defines "real" user groups.

CENTRALGROUP=/etc/group.fys

getent passwd | awk -F: -vCENTRALGROUP=$CENTRALGROUP '
BEGIN {
        # Get the central groups list of GIDs
        while (getline < CENTRALGROUP ) {
                split($0,b,":")  # Split group line into fields
                gidlist[b[3]] = b[3]    # GID (numeric group id)
        }
}
{
	for (g in gidlist) {		# Search the real users group list
		if ($4 == gidlist[g]) {	# $4 is the user GID
			print $1	# Print username
			next
		}
	}
}'
