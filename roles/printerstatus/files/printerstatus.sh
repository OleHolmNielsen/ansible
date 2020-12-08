#!/bin/sh

# Inquire a list of printers by SNMP for status messages (toner etc.)
# Send mail to user if selected by -m

# Parse command options
while getopts "am:h" options; do
	case $options in
		a )	listall=1
			;;
		m )	export mailuser="$OPTARG"
			;;
		h | * ) echo "Usage:"
			echo "Listing: $0 [-a] [-m mailuser]"
			exit 1;;
	esac
done
shift $((OPTIND-1))

TMPFILE=/tmp/printerstatus.$$
rm -f $TMPFILE

if test $# -gt 0
then
	export PRINTERLIST="$@"
else
	# Default list: all printers
	export PRINTERLIST="b307-m830 ly307-225-co1 ly307-225-bw1 hpz6200 b307-m602 ly307-east-co1 case4015 ly307-001-bw1 b309-m725 cryoprt b309-4525 b309-4525-2 ly309-219-co1 ogprint ws4525 b309-m577 ppfe-5550dn b311-4525 ly311-070-co1 b312-m725 cinf4015 b312-m553 ipf8300"
fi

# Our SNMP read-only community string (default: public):
export COMMUNITY="public"

# snmpwalk is from the net-snmp-utils RPM:
SNMPWALK=/usr/bin/snmpwalk
PING="/bin/ping -c 1 -w 3"
# HP printers status message MIB:
STATUSMIB="SNMPv2-SMI::mib-2.43.18.1.1.8.1"
LOCATIONMIB="SNMPv2-MIB::sysLocation.0"
DEVICEMIB="HOST-RESOURCES-MIB::hrDeviceDescr.1"

# Filtering of messages by sed:
IGNORE="-e /Instance/d -e /Sleep/d -e /deleted/d -e /Ready/d -e /finished/d -e /Powersave/d -e /Checking/d -e /Preparing/d"
EDIT="-e /$STATUSMIB/s//Status/ -e /STRING:/s///"

if test ! -x $SNMPWALK
then
	echo $SNMPWALK does not exist, install the net-snmp-utils RPM
	exit -1
fi

for p in $PRINTERLIST
do
	SNMPARGS="-c $COMMUNITY -v 2c"
	if test "$p" = "ipf8300"
	then
		SNMPARGS="-c $COMMUNITY -v 1"
	fi

	# Ping the host to see if it is alive
	if $PING ${p} 2>&1 > /dev/null
	then
		# LOCATION="`$SNMPWALK $SNMPARGS $p $LOCATIONMIB 2>&1 | awk -F: '{print $4}'`"
		# DEVICE="`$SNMPWALK $SNMPARGS $p $DEVICEMIB 2>&1 | awk -F: '{print $4}'`"
		LOCATION="`$SNMPWALK $SNMPARGS $p $LOCATIONMIB 2>&1 | cut -d ' ' -f 1,2,3 --complement`"
		DEVICE="`$SNMPWALK $SNMPARGS $p $DEVICEMIB 2>&1 | cut -d ' ' -f 1,2,3 --complement`"
		# Cut the initial "Status.* = " string
		# MESSAGE=`$SNMPWALK $SNMPARGS $p $STATUSMIB 2>&1 | sed $IGNORE $EDIT | cut -d " " -f 1,2 --complement`
		# MESSAGE=`$SNMPWALK $SNMPARGS $p $STATUSMIB 2>&1 | sed $IGNORE $EDIT | awk -F\" '{print $2}'`
		# MESSAGE=`$SNMPWALK $SNMPARGS $p $STATUSMIB 2>&1 | sed $IGNORE | cut -d " " -f 1,2 --complement | awk -F\" '{print $2}'`
		MESSAGE=`$SNMPWALK $SNMPARGS $p $STATUSMIB 2>&1 | sed $IGNORE | cut -d ' ' -f 1,2,3 --complement | sed '/\"/s///g'`
	else
		LOCATION=""
		DEVICE=""
		MESSAGE="!!!!!!!!!!!!!!!!!!!	Cannot ping printer ${p} !"
	fi
	# If MESSAGE is non-empty or listall!="", print the printer information
	if test -n "$MESSAGE" -o -n "$listall"
	then
		cat <<EOF >> $TMPFILE
======================== 
Printer:	$p
Location:	$LOCATION
Printer model:	$DEVICE
Web page:	https://$p.fysik.dtu.dk (http://$p.fysik.dtu.dk)
EOF
	fi
	if test -n "$MESSAGE"
	then
		cat <<EOF >> $TMPFILE

NOTICE: ${MESSAGE}

EOF
	fi

done

# Print the messages
if test -s "$TMPFILE"
then
	if test -z "$mailuser"
	then
		cat $TMPFILE 
	else
		# Send mail to the specified user
		cat $TMPFILE |& mail -s 'Fysik printers status' $mailuser
	fi
fi
rm -f $TMPFILE
