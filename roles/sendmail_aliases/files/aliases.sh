#!/bin/sh

# Concatenate files into a combined /etc/aliases file

FILES="aliases.orig aliases.fysik aliases.dtubasen"
ALIASES=/etc/aliases

# The aliases files live in /etc
cd /etc

# Make a backup file
cp -p $ALIASES $ALIASES.BAK
rm -f $ALIASES.NEW

for i in $FILES
do
	cat <<EOF >> $ALIASES.NEW
######################################################################
###
### Input file $i
###
EOF
	cat $i >> $ALIASES.NEW
done

# Update aliases database
if test -n "`diff $ALIASES.NEW $ALIASES.BAK`"
then
	mv -f $ALIASES.NEW $ALIASES
	newaliases > /dev/null
fi
