#!/bin/sh

# Synopsys license manager
# TOPDIR=/opt/flexlm/synopsys/scl/2018.06
TOPDIR=/opt/flexlm/synopsys/scl/2018.06-SP1
LMGRD=$TOPDIR/linux64/bin/lmgrd
log_path=${TOPDIR}/admin/logs/lmgrd.log
license_file_list=${TOPDIR}/admin/license/*.txt

if test -x $LMGRD
then
	echo Starting FlexLM Synopsys license daemon
	echo License server in file:
	grep '^SERVER' $license_file_list
	# The -l logfile seems not to work
	exec $LMGRD -l $log_path -c $license_file_list 
else
	echo FlexLM Synopsys license daemon file $LMGRD not found
fi
