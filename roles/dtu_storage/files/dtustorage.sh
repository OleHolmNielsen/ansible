#!/bin/bash
#Add 2 variables to users ~/.bashrc file for the DTU HPC Storage
#only if they already have an entry in the usermap file
#
FILE=$HOME/.bashrc
[ ! -f $FILE ] && touch $FILE
if [ -f /dtu/hpc.scratch/.userpathmap ] ; then
    storagepath=$(awk -F: -vuser="$USER" '$1==user {print $2}' /dtu/hpc.scratch/.userpathmap)
    if [ "$storagepath" ] ; then
        line1="# Added by DCC for HPC Storage"
        grep -q "$line1" "$FILE" || echo "$line1" >> "$FILE"
        line2="export DTUHPCSCRATCH=/dtu/hpc.scratch/${storagepath}"
        grep -q "$line2" "$FILE" || echo "$line2" >> "$FILE"
        line3="export DTUHPCDATA=/dtu/hpc.data/${storagepath}"
        grep -q "$line3" "$FILE" || { echo "$line3" >> "$FILE" ; printf "\nVariables have been added to your $FILE\nTo take affect now source the file\n\n    . $FILE\n" ; }
    else
         printf "\n$USER directory does not exist on the DTU HPC Storage.\nIf you need them added please contact support@cc.dtu.dk\n"
fi
fi

