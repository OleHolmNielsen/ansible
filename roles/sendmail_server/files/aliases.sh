#!/bin/sh

# Concatenate files into a combined /etc/aliases file

FILES="aliases.orig aliases.fysik aliases.dtubasen"
ALIASES=/etc/aliases

# The aliases files live in /etc
cd /etc

# Make a backup file
mv $ALIASES $ALIASES.BAK

for i in $FILES
do
	cat <<EOF >> $ALIASES
######################################################################
###
### Input file $i
###
EOF
	cat $i >> $ALIASES
done

# Update aliases database
if test -n "`diff $ALIASES $ALIASES.BAK`"
then
	newaliases > /dev/null
fi
