INSTALL.TXT for sshblack.pl Version 2.8.1

see http://www.pettingers.org/code/sshblack.html

pettingers (at) gmail.com

================================================


Simple/Expert Install Instructions
----------------------------------

1.  As root, unpack the script from the tar archive and place it in your 
directory of choice. 'tar -xvzf sshblack.tar.gz'

2.  Make the script executable.  'chmod 755 sshblack.pl'

3.  If you would like to use a firewalling mechanism other than iptables, please 
skip to step 4.  If you are using the iptables configuration (recommended) 
you may need to make a new iptables chain in your current iptables config.
  You can use the default INPUT chain if you don't 
mind that.  Verify the correctness of $ADDRULE and $DELRULE near the start of 
the code or, by all means, enter your own rules.  Just substitute the word 
"ipaddress" where your would normally put the IP address of the attacker.  So:
         iptables -I INPUT -s 192.168.1.1 -j DROP
becomes
         iptables -I INPUT -s ipaddress -j DROP
You can of course have the script add things to a custom chain instead of the 
INPUT chain.  The default name for this chain in the script is BLACKLIST but you 
can change this (and modify the script accordingly) if required.  If you use a 
custom chain, remember to create the chain.  The command 'iptables -N BLACKLIST' 
usually works but you might need to adjust the path to iptables.  Be sure to 
use the same type of commands for $ADDRULE and $DELRULE.  That is, dont' use
iptables for one command and ipchains for the other! 
   Make sure ssh packets are run through the BLACKLIST chain if required. 
Depending on your current iptables configuration, you will need to decide where
to put the jump rule to the BLACKLIST.  Be sure you have a basic understanding 
of iptables before you configure it!  Normally you would do something like
'iptables -I INPUT -p tcp --dport 22 -j BLACKLIST' 
but you may not want to make it the first rule in the INPUT chain.  
Use '-I INPUT 3' or '-I INPUT 7' or wherever you need it to go.  
You can try 'iptables -A INPUT -p tcp --dport 22 -j BLACKLIST' which 
will put it at the end of the rules for the INPUT chain but you need to make 
sure that another rule is not going to ACCEPT the ssh connections before 
BLACKLIST has a chance to drop them.  Move on to step 5.

4.  If you are using another firewall mechanism instead of iptables, make sure 
$ADDRULE and $DELRULE are set correctly near the top of the code.  Different OS 
variants have significantly different requirements for firewalling commands. 
Just substitute the word "ipaddress" where you would normally put the IP address
of the attacker.

5.  Modify the other variables near the top of the script to suit your needs.  
See "Fine Tuning and Internal Configuration" below for detailed descriptions of 
each variable.  Defaults are already applied and should work for most 
applications.  IMPORTANT: Check the white list REGEX and make sure it is set to 
white list any hosts you never want to blacklist.

6.  If you have the $DAEMONIZE variable set, you can start the script simply by
typing the name of the script at the command prompt and it will go into the 
background automatically.  If $DAEMONIZE is cleared (set to 0) the script will
run on the command prompt (good for testing, not much else).


Complete Install Instructions
-----------------------------
Note: The following instructions are VERY elementary which some could argue is 
ridiculous given the nature of the sshblack script.  That is, if someone doesn't 
know how to unpack a tar ball, they probably shouldn't be working with scripts 
that modify iptables!  Yet it is included here for completeness, however 
academic it might be.  There is a certain amount of complexity in what the 
administrator will be undertaking here.  Please excuse the necessary verbosity 
of this text and please skip ahead as required.


1.  Confirm that you have the following prerequisites complete:
	a) You are running Linux, Unix or some similar *nix variant.  As far as we 
know, this script has no applicability to Windows machines.
	b) You are running an SSH daemon that accepts ssh connection requests from 
outside networks.  That is, after all, the whole point of the script!
	c) Your kernel supports (and is using) netfilter/iptables.  See: 
http://www.netfilter.org/  Using the script with ipchains would be 
fairly easy.  If you do not have iptables, please see the sshblack homepage for
many examples of other firewalling mechanisms.  Iptables is strongly recommended.
	d) You have the Perl language interpreter installed.  There are no special 
modules or libraries required and any relatively recent version of Perl should 
work fine.  You can check this by typing 'perl -v' from the command prompt.
	e) You have superuser (root) access to the host.  You can enter superuser 
by typing 'su -' and entering the correct password.
	f) You need to have a very basic understanding of iptables if you are
using iptables to do the firewalling because the initial 
configuration will require some manual intervention.  You may want to have a 
look at http://www.pettingers.org/firewall.html which gives a very simple 
configuration for a basic firewall.  If you are using a shell script from 
someone or some other package to "install" a firewall with iptables, you need to 
be familiar with what they are doing.  You should be able to type
'iptables -L -n' as root.  If you look at the output from this command and don't
have a clue what you are looking at, you might want to brush up a bit before going
further or you're going to hurt yourself.

2.  Download the latest sshblack script from 
http://www.pettingers.org/code/sshblack.html  It is normally available as an 
archive in tar.gz format.  If you are reading this file, you have probably 
already done this!  In our example we will assume the file is downloaded to 
/home/bubba/ but you can obviously download it to any directory you like.

3.  Become root.  You will need this later on.

	su -
	[enter correct password when prompted]

4.  Move the file to a suitable directory.  It should run correctly from 
anywhere.  Since you will only be running it as root, you may want to place it 
somewhere that only root can see it.  For the following discussion, we will use 
the directory /usr/src/sshblack/ but you can certainly use anything you like.  
So we will make that directory and move the archive there:

	mkdir /usr/src/sshblack
	mv /home/bubba/sshblack.tar.gz /usr/src/sshblack/
	cd /usr/src/sshblack


5.  Unpack the archive.

	tar -xvzf /usr/src/sshblack/sshblack.tar.gz

6.  You should now see the Perl file and some associated documentation.  We need 
to make sure the file is executable if it isn't already.  

	chmod 755 /usr/src/sshblack/sshblack.pl

7.  We now want to configure the parameters of the script to customize it for 
our application.  You can do this with any text editor such as vi (or vim) or 
emacs.  You will see the user-configurable parameters near the top of the 
script.  Please see the section below on "Fine Tuning and Internal 
Configuration" for details on each parameter.  The script will generally work 
fine AS IS, but it is worth a look at the parameters to see if there is anything 
you want to fine tune.  Some things you really should check:
	a) Make sure the path to Perl is correct in the very first line of code.  
/usr/bin/perl is assumed.
	b) Confirm the path to your security log is correct.  /var/log/secure is 
assumed.
	c) Make sure the $REASONS line is exactly correct, case and all (see more 
details of this below in Fine Tuning and Internal Configuration).
	d) Make sure the whitelist is configured correctly.  PLEASE see the 
README.TXT file FAQ section for a quick tutorial on working with the whitelist.

8.  You need to decide now whether you are going to use iptables or some other
method of firewalling. 
   The "choosing" is done by selecting different versions of the $ADDRULE and 
$DELRULE near the top of the code, in the user-configurable parameters section.  
Obviously both $ADDRULE and $DELRULE need to both be the same type of commands. 
   You may notice that all the $ADDRULE and $DELRULE examples in the script have 
the literal word, "ipaddress" in them.  This is simply a placeholder.  As the 
script runs, it will substitute the actual IP address of the attacker in place 
of the literal ipaddress string.  So you want to make sure that "ipaddress" is 
placed inside the command in the same spot you would normally insert an IP 
address.  Look at the examples already in the code and this should make sense.

9.  We are now ready to prepare the iptables chains to work with sshblack.  It 
can not be stressed enough: If you do not know what you are doing with iptables, 
please tread lightly, get some help, and become better educated on the details.  
You can lock your network out completely if you do not do things correctly.  
   We will start by creating the chain that iptables will use to hold our 
blacklisted hosts.  The script expects this chain to be called 'BLACKLIST' 
[pretty imaginative, eh?] but you can call it anything you like as long as you 
modify the script (specifically $ADDRULE and $DELRULE) accordingly.  
Note that if you don't mind adding blacklisted hosts to your default INPUT 
chain, you do not need to create the BLACKLIST chain (or add the jump to that 
chain).  That is, if your $ADDRULE and $DELRULE use INPUT instead of BLACKLIST,
you can skip down to step 10.

9.a.  This step assumes that you are running SOME FORM OF PREPARED OR PRE-
PACKAGED FIREWALL SCRIPT on your host.  If you have not modified the iptables 
configuration, either manually or by running another piece of code, please skip 
down to step 9.b.

It must be stated up front that complete knowledge of every single firewall 
configuration is impossible but we will try to give some pointers for those 
attempting to integrate sshblack into an existing configuration.  It is actually 
very simple if you have a basic understanding of iptables and how packets 
traverse the rule chains.  There are really only a few things you must do, but 
exactly HOW you do these depends greatly on your existing configuration.

	1. Create a new chain called BLACKLIST.  This assumes that there is no 
existing chain called BLACKLIST.  If there is, you'll want to rename this chain 
for sshblack, call it something like SSHBLACKLIST and modify the script 
accordingly.  If we assume you do NOT already have an existing BLACKLIST chain 
as part of your iptables config, we can use this to create the new chain:

	iptables -N BLACKLIST

	2. Send ssh packets through this chain BEFORE they are accepted by another 
rule.  This is where you need to do some detective work.  We will most likely be 
working in the INPUT chain (which will certainly exist no matter what existing 
firewall configuration you have).  You need to look at the rules in the INPUT 
chain, starting from the top rule.  Commonly this rule will include something 
like "...RELATED, ESTABLISHED... -j ACCEPT" but may be something else.  You may 
see something for the local interface: "... -i lo... -j ACCEPT".  Yet 
eventually, as you look through the rules from the top, you will start seeing 
jumps (-j) to custom rules that are part of the firewall script or program you 
are running.  You generally want to put our next rule BEFORE these other jumps 
but AFTER anything that deals with RELATED, ESTABLISHED which are part of the 
stateful filtering of iptables.
	We can insert rules into the correct place with the -I command of 
iptables.  The number following the chain name is the numerical position for the 
new rule in the chain.  So, for example, if our existing rules look like this:


[root@stinky root]# iptables -L INPUT -n
Chain INPUT (policy DROP 0 packets, 0 bytes)
 target     prot opt in    out source      destination
 ACCEPT     all  --  eth0  *   0.0.0.0/0   0.0.0.0/0   state RELATED,ESTABLISHED
 ACCEPT     all  --  lo    *   0.0.0.0/0   0.0.0.0/0
 filter01   tcp  --  *     *   0.0.0.0/0   0.0.0.0/0   tcp dpt:25
 access-web tcp  --  eth0  *   0.0.0.0/0   0.0.0.0/0   tcp dpt:80 

      ........ other rules .........
[root@stinky root]#

	Well, we may not be sure what the "filter01" and "access-web" chains do, 
but at this point we really don't care.  Let's put our sshblack rule in front of 
those custom rules yet after the "lo" rule and the "RELATED, ESTABLISHED" rule.  
We need to be in position 3. So our insert command would look like this:

	iptables -I INPUT 3 -p tcp --dport 22 -j BLACKLIST

	We should now have our rule at position 3, all the existing rules will be 
increased by one position.  What this will do is pass all TCP traffic on port 22 
(ssh) down to the BLACKLIST chain.  If the source (remote) IP address of this 
traffic is listed there, the packet will be dropped.  Processing of that packet 
will stop there.  Just as importantly, if the source IP address is NOT in the 
BLACKLIST chain, the packet will return to the INPUT chain for continued 
processing at rule number 4.
	This leaves the original functionality of your firewall configuration 
intact, it simply inserts an extra check for ssh traffic.  This is true even if 
your existing firewall already had other rules that dealt with ssh traffic 
(which it probably does).

	3.  The point is, packets can be sent to the BLACKLIST at any time but 
they must be sent BEFORE they are accepted by any other rule and probably AFTER 
any stateful filtering or administrative house-keeping rules.  You could also 
call the BLACKLIST chain from chains other than the INPUT chain with equal 
effectiveness.  Again, to decide where to do all this only makes sense if you 
understand what your firewall package is doing with each packet it processes.  
You can go on to step 10.

9.b. This assumes that you have NO EXISTING FIREWALL IPTABLES CONFIGURATION.  
That is, iptables is in a default configuration without modifications to any of 
the default chains, INPUT, FORWARD, and OUTPUT.  You have not run any prepared 
firewall script or package.  We can confirm this by typing:

	iptables -L

This should show only the default chains and no rules:

[root@stinky root]# iptables -L -n -v

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
 
Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

[root@stinky root]#

If you can confirm that there are no existing rules, you are welcome to run the 
very simple setup script included in the sshblack.tar.gz file called 
iptables-setup.sh

For completeness or for those that prefer not to run the script (good for you!), 
let's look at the important things we are doing here.

	iptables -N BLACKLIST

We are creating a new chain called BLACKLIST.  This command by itself does 
nothing to affect traffic traversing the machine.  You could create a thousand 
chains like this but as long as no traffic is DIRECTED to these chains, they 
don't affect anything.  So let's put some traffic through the new chain.

	iptables -A INPUT -p tcp --dport 22 -j BLACKLIST

All we are doing here is directing all TCP traffic on port 22 through the 
BLACKLIST chain.  What's in the BLACKLIST chain?  At this point, nothing.  Yet 
the sshblack script will be adding REJECT or DROP rules to this chain to drop 
packets from attackers.

That's pretty much the meat of it.  There are many other/better things you can 
do with iptables, but this is enough to get your sshblack running.


10.  Now that everything is prepped, the script can be started.  Since the 
script was already made executable in step 6 you can simply run it from the 
command prompt if you like by typing the filename.  However, the action of the
script will depend on the setting of the $DAEMONIZE variable.  If the variable
is set to '0' (do not daemonize) the script will run but will log all output to
the console window and, more importantly, would terminate as soon as you 
logged out of your terminal session.  Setting $DAEMONIZE to '1' will allow the
script to place itself in the background and run like any other daemon.  
You can now log out and have the script running safely in the background.

Logging should appear in your logfile of choice (see "Fine Tuning and Internal
Configuration" below).  It would be a good thing to put this type of script in
one of your startup directories so it can start fairly soon after your machine
boots.



Things to Consider
------------------

Generally, rebooting the machine will erase your iptables configuration.  This 
not only erases the rules in the BLACKLIST chain -- your attackers -- but also 
erases the entire BLACKLIST chain.  If you do not save your iptables 
configuration before you reboot, your sshblack script will have no BLACKLIST 
chain to add rules to.  You can either save your iptables or recreate things 
after you reboot.  How you do this is up to you.  If you are using a Red Hat 
Linux, they commonly have the 'iptables-save' and 'iptables-restore' commands 
available and they work well.  It would be advisable to save things in a daily 
cron job.




Fine Tuning and Internal Configuration
--------------------------------------

Several variables are available for tuning the script.  Default values are 
already entered in the script and will run fine for most applications right out 
of the box.  These variables are detailed below.

$DAEMONIZE will allow the script to run in the background (via fork) and will
essentially create a daemon out of the script.  If this is set to '1' it will
place the executing script in the background.  If set to '0' it will run from
the command prompt and log all output to the terminal (useful for debugging,
not much else).

$LOG is the log file to monitor, commonly set to '/var/log/secure' but might be 
'/var/log/messages' or '/var/log/syslog' and should include a complete path.

$OUTPUTLOG is the log file for output from the sshblack script.  It will log
everything from STDOUT and STDERR.  You can certainly send this to /dev/null if
you don't want to see this output.  Default is '/var/log/sshblacklisting'.

$CACHE is the file used to store the working database of IP addresses.  This 
includes both addresses that are already blacklisted and those that are 
"addresses of interest" that have done something suspicious but have not yet 
crossed the threshold to be blacklisted.  The database is composed of one line 
per address, three comma-separated elements per line.  The form is:

   ip_address,epoch_time,attack_count

   IP address is the dotted notation for the "attacking" host.  The time is 
epoch time (seconds since Jan 01, 1970).  The attack count is an integer 
representing of the number of distinct attack patterns seen from the respective 
host since it was first "observed".

$LOCALNET is a whitelist of hosts and/or networks.  This is recorded in REGEX 
notation and can include any hosts and networks that should NOT be blacklisted, 
regardless of activity.  A good tutorial on REGEX should be consulted for help 
on this if needed.  There is also a little tutorial on the sshblack homepage.
   
$ADDRULE is the command line option used to ADD things to the blacklist.  You 
can use route commands, iptables commands, ipchains commands....  Whatever 
command you use, the sshblack script will execute this command when it is 
triggered.  Some example commands are on the sshblack homepage.  The only 
special thing you need to do is substitute the literal character string 
'ipaddress' in the location where you would normally put the actual IP address.  
The script will search for this string and replace it with the attacker's 
address as needed.

$DELRULE is the command line option used to DELETE things from the blacklist.  
You can use route commands, iptables commands, ipchains commands....  Whatever 
command you use, the sshblack script will execute this command when it removes 
addresses from the blacklist.  Some example commands are on the sshblack 
homepage.  The only special thing you need to do is substitute the literal 
character string 'ipaddress' in the location where you would normally put the 
actual IP address.  The script will search for this string and replace it with
the attacker's address as needed.

$REASONS is the exact, case sensitive REGEX of items that should be considered 
"attacks".  For most modern versions of sshd, the common setting of '(Failed 
password|Failed none)' works well.  It is usually best to NOT use both 'Failed 
password' and 'Illegal user' as some ssh daemons record both of those for a 
single failure and it could produce duplicate counts.

$AGEOUT is a timing variable expressed IN SECONDS.  This is the amount of time 
before a suspect IP is removed from the database unless it is already 
blacklisted.  That is, if an attacker has not reached $MAXHITS (see below) 
attacks by the time $AGEOUT has expired, he will be removed from the database 
and NOT be blacklisted.  Commonly set to 600 seconds (10 minutes).

$RELEASEDAYS is a timing variable expressed IN DAYS.  This is the amount of time 
before a blacklisted host is removed from the blacklist.  Commonly set to 3 but 
can be anything deemed reasonable.

$CHECK is a timing variable expressed IN SECONDS.  This is an internal timer 
used as an interval for parsing the database.  Every $CHECK seconds, the script 
will open the database, see a) if anyone who is already blacklisted should be 
released from the blacklist, b) if any suspicious IPs should be dropped from the 
database because they have reached $AGEOUT seconds and are not currently 
blacklisted.  Commonly set to 300 seconds (5 minutes) and should not be set too 
low (not less than 60 seconds) or too high (not more than 3600 seconds).

$MAXHITS is the number of "attacks" allowed before the IP will be blacklisted.  
This is commonly set to 4 or 5.  This should not be set extremely low so as to 
allow for legitimate users to mistype their password.  It should also not be set 
extremely high (e.g. 100) as it would reduce the effectiveness of the script.  
Any legitimate user is going to be well below three or four attempts and any 
trojan/hacker is going to be above five or six attempts so it is best to keep it 
in this range.
 
$DOSBAIL is a denial-of-service counter.  If the script detects that more than 
$DOSBAIL IPs are listed in the database, it will hibernate for one day and do 
nothing.  This is done in an attempt to keep an attacker from spoofing source 
addresses and loading up the iptables chain with an enormous number of addresses 
(if this is even possible).  It is assumed an administrator would notice the 
huge number of attack attempts and do something to obviate the problem.  This is 
commonly set to 200 but can be adjusted to whatever the administrator feels is 
reasonable.  Obviously setting the number too low could cause premature 
hibernation.

$CHATTY determines the amount of logging output produced.  0 and 1 are the only 
options.  A setting of 0 will produce limited output.  A message will be 
produced when the script starts and each time a host is blacklisted or released.  
A setting of 1 will produce more output in the form of notices each time a host 
trips a single $REASON even if it hasn't reached $MAXHITS to be blacklisted yet.  
It defaults to 1 which is usually acceptable for most applications and makes 
testing a bit easier.

$EMAILME is used to decide if the script will E-mail the administrator when
certain events occur.  0 and 1 are the only options.  A setting of 1 will cause
E-mails to be generated only when an address is added to or released from the
blacklist.

$NOTIFY is the E-mail address of the administrator monitoring sshblack activity.
The can be left as 'root' or it can be set to any local user such as 'webmaster'
or it can be set to a valid SMTP address such as 'bubba@example.com'.  Obviously
E-mail is sent to this address only if $EMAILME is enabled.

