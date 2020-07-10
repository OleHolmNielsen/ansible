#!/bin/sh

# Synopsys license manager
TOPDIR=/opt/flexlm/synopsys/scl/2018.06
LMDOWN=$TOPDIR/linux64/bin/lmdown
log_path=${TOPDIR}/admin/logs/lmgrd.log
license_file_list=${TOPDIR}/admin/license/*.txt

if test -x $LMDOWN
then
	echo Stopping FlexLM Synopsys license daemon using license file $license_file_list
	echo License server in file:
	grep '^SERVER' $license_file_list
	# The -l logfile seems not to work
	$LMDOWN -c $license_file_list 
else
	echo FlexLM Synopsys license daemon file $LMDOWN not found
fi
