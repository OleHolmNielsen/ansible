#!/bin/tcsh
#Add 2 variables to users ~/.tcshrc file for the DTU HPC Storage
#only if they already have an entry in the usermap file
#
setenv FILE $HOME/.tcshrc
if ( ! -f $FILE ) then  
touch $FILE
endif
if ( -f /dtu/hpc.scratch/.userpathmap  ) then
    set storagepath = `awk -F: -vuser="$USER" '$1==user {print $2}' /dtu/hpc.scratch/.userpathmap`
    if ( $storagepath != ""  ) then
        setenv line1 "# Added by DCC for HPC Storage"
        grep -q "$line1" "$FILE" || echo "$line1" >> "$FILE"
        setenv line2 "setenv DTUHPCSCRATCH  /dtu/hpc.scratch/${storagepath}"
        grep -q "$line2" "$FILE" || echo "$line2" >> "$FILE"
        setenv line3 "setenv DTUHPCDATA  /dtu/hpc.data/${storagepath}"
        grep -q "$line3" "$FILE" || ( echo "$line3" >> "$FILE" ; printf "\nVariables have been added to your $FILE\nTo take affect now source the file\n\n    source $FILE\n"  )
     else
        printf "\n$USER directory does not exist on the DTU HPC Storage.\nIf you need them added please contact support@cc.dtu.dk\n\n"
     endif
endif

