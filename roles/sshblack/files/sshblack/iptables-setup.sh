#! /bin/bash

# This script performs the iptables setup for the sshblack
# blacklisting script.  See http://www.pettingers.org/code/sshblack.html
# for details.
# DO NOT RUN THIS SCRIPT if you have existing iptables rules as
# it may over-write or duplicate existing rules.


iptables -N BLACKLIST
iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j BLACKLIST

