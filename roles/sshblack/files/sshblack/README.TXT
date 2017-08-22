README.TXT for sshblack Version 2.8.1

see http://www.pettingers.org/code/sshblack.html

pettingers (at) gmail.com

================================================

Background and Release Notes
----------------------------
I originally stumbled on to mailmgr.pl written by Julian Haight when I was 
looking for some good anti-spam tools.  Mr. Haight is the man behind the 
fantastic spamcop.net site and the accompanying real-time DNS blacklist.  The 
mailmgr script was a stand-alone blacklisting script that could be used with 
almost any mail program to monitor log files and manage an iptables blacklist 
based on the activities recorded in the log.  At the time, I didn't see the need 
for blacklisting smtp traffic as most relay attempts come and go pretty quickly 
and real-time DNS blacklists work very well.

However, I liked the idea of tailing a log file and decided to apply the concept 
to both web site logs (http://www.pettingers.org/code/davblack.html) and ssh 
logs (http://www.pettingers.org/code/sshblack.html).  Starting in the spring of 
2004 (and some historical sites report it long before that) I noticed a large 
amount of ssh hacking attempts on my Linux hosts.  They were clearly bots or 
trojans, none successfully entering my system but it left hundreds of lines of 
hack attempts in my logs and struck me as something very unhealthy.

Version 1.  The original sshblack script simply monitored my /var/log/secure 
file and looked for tale-tell signs of the hacking attempts.  By far most of 
them were identified by attempts at the username "test" and "guest" and -- for 
some odd reason -- "jordan".  So if I saw any of those login failures I would 
add the originating IP address to a chain in my iptables configuration.  I could 
not watch for ANY failed log in attempts because there was always the 
possibility that I would mis-type my password and I didn't want to blacklist 
myself.  The script also had a rudimentary FIFO set up so that after 100 
addresses got added to the list, the oldest addresses would be removed.  This 
worked well enough and put a significant dent in the amount of hacking in my log 
files.  It had several problems that I attempted to resolve in the next version.

Version 2.  This was a major re-write and had significant improvements over the 
older version.  The older Version 1 code had an annoying habit of duplicating 
blacklist entries because it blindly added entries to the blacklist without any 
historical perspective.  When my machines would get hit simultaneously by the 
same attacking host, those attackers ended up being listed two or three times in 
the blacklist.  Truthfully, this didn't matter too much because being listed 
once in a blacklist is just as good as being listed three times.  It was messy 
though.  

Also, the FIFO idea was problematic in that it would push out entries that I 
wanted to be permanent.  It also didn't clear out dynamic addresses quickly 
enough (this was mostly a problem for the web-based version of my program, 
davblack.pl).  All of these problems could be solved by keeping a separate 
database of attackers.  This would allow me to keep track of each attacker to 
add and delete them from the blacklist as required.  

The database would also add some historical perspective to the code in that I 
could watch ALL failed log-in attempts and see how quickly they are coming in.  
So I could blacklist login attempts for not only "guest" and "temp" and "jordan" 
but also my real usernames and root.  I could set the threshold high enough that 
one password failure for root would not cause a blacklisting but four of them 
within two minutes WOULD cause a blacklisting.

Version 2.1 and 2.2.  These were maintenance releases that fixed minor bugs and 
typos.  Nothing interesting.

Version 2.3.  This version introduced some denial-of-service avoidance code.  
Much of the discussion and comments about the script centered on the assertion 
that, if someone knew you were running the script, they could spoof source 
addresses and get you to blacklist yourself.  This is not, and never was, the 
case.  A whitelist was included since Version 1 and there are other fallacies 
regarding this theoretical weakness but that is beyond the scope of this 
document.  However, someone did point out that if an attacker could cause the 
script to detect enough spoofed attacks, the iptables chain could grow without 
bounds.  However, there are (at least) two problems with this theory also.  
First, my experience shows that iptables chains can become enormous without 
significantly affecting the operation of the machine or traffic flow.  This 
assumes that your iptables are constructed efficiently and utilize things like 
ipconntrack.  Secondly, I'm not convinced that a simple source spoofing or SYN 
attack could cause the script to fire.  Anyway, I decided that I could easily 
add some sanity checks to the database.  So if there are more than 50 
(adjustable) entries in the database, the script goes into hibernation for a 
period of time and expects you to solve the problem.  Resolving the DoS is left 
as an exercise to the student.

Version 2.4.  This is a very minor upgrade from 2.3.  Users of 2.3 will see no 
major improvements in performance and could easily ignore this release.  Version 
2.4 adds some comments to the code (for those interested) and also adds some 
logging improvements.  I had been receiving some very appropriate questions 
about what the script is actually doing, or if it was doing anything at all!  
This stemmed from the rather terse output from the script.  So I added some 
verbosity that can be turned off for those that don't want a chatty script.  

It now tells you not only that it is "Initializing" but also that it is 
"monitoring for future attacks" which will hopefully eliminate the source of 
confusion for a number of users.  It also gives you output for EVERY "attack" it 
notices, not just those that actually cause blacklisting.  This is helpful for 
testing and also gives you information about attackers that might be dancing 
lightly to avoid attention (e.g. manual attacks rather than trojans and 
scripts).

Version 2.5.  This version introduced the use of the Proc::Daemon module to 
automatically put the script into the background.  It makes things a bit more 
tidy in terms of logging output (another user-configured parameter was added for 
this) and its a bit easier for less experienced users who don't know how to get 
things in the background.  By far most of the heavy-lifting code is identical to 
Version 2.4.

Version 2.6 and 2.6 Daemon.  One of my users noted that there are a large number 
of machines that don't have iptables available.  However many of them (if not 
all) have route.  He also pointed out a little trick of routing a host to 
localhost which effectively buries the packets.  I do not believe it is as 
secure as iptables but it is a good option for people that want to use it.  I 
also took this opportunity to clean up the code and make things more obvious and 
more maintainable.  It is now extremely easy to make the script use route, 
iptables or ipchains or execute any command you like.  I still don't like the 
idea of forcing a Perl module on people, even if it is a tiny and useful one 
like Proc::Daemon.  So I have kept the version number the same at 2.6 but now 
have a daemon version which uses Proc::Daemon and a non-daemon version which can 
be placed into the background manually.

Version 2.7 and 2.7 Daemon.  The logging is now much neater and is done by a 
separate subroutine.  This same logging subroutine will also send an E-mail to
the administrator if you so desire.  I have also included some simple utility
scripts that can do blacklisting and un-blacklisting but also modify the actual
CACHE file used by sshblack.  It does this "behind the back" of sshblack and there
is no file locking when it does this (that's for another version).  However the
chances of a collision are probably small.

Version 2.8.  With the help of one of my users, I implemented a very simple fork
to place the script in the background.  This eliminates the need for Proc::Daemon
and allows the user to decide how to do this with a configuration variable.  This
version also allows you to customize the E-mail address for notices instead of
only sending to root.  This version also originally had reverse DNS lookups 
enabled where it would look up the FQDN of the IP address and report that in the 
E-mails and logs.  I pulled this at the last minute over concerns about DNS 
failures/delays and what it would do to script execution.  This capability may 
make it back into a future version.

Version 2.8.1.  The is a minor fix to address a potential DoS attack against 
sshblack.  This potential attack could be minimized by proper use of the 
whitelist however the ability of attacker to fill up your blacklist quickly 
still exists without this fix.  The attack vulnerability arises when an attacker
places dotted IP addresses in the username field of their SSH initiation.  So if
the attacker uses something like 192.168.100.100 for their username, the log lines
appears as:

Nov 11 19:17:57 stinky sshd[31205]: Invalid user 192.168.100.100 from 209.131.36.158

Previous versions of sshblack would pick up the first IP address in the log lines, 
not the last.  So in this example, it would eventually blacklist 192.168.100.100 
instead of the actual attacker at 209.131.36.158.  This was easy to solve by 
modifying the REGEX that looks for the IP address.  This was the only functional
change made from Version 2.8.


FAQ (No, really, I get these all the time)

Please also see http://www.pettingers.org/code/sshblack-notes.html for things
not covered here.
-------------------

1) What is sshblack?  

   The sshblack script is a real-time security tool for secure shell (ssh).  It 
monitors *nix log files for suspicious activity and reacts appropriately to 
aggressive attackers by adding them to a "blacklist" created using various 
firewalling tools -- such as iptables -- available in most modern versions of 
Unix and Linux.  The blacklist is simply a list of source IP addresses that are 
prohibited from making ssh connections to the protected host.  Once a 
predetermined amount of time has passed, the offending IP address is removed 
from the blacklist.
   It is written in Perl but requires no special modules or libraries unless you 
utilize the daemon version which only requires one tiny module.
   What defines an "attack" is determined by a variable in the source code.  
This is usually a character string like "Failed password" or "Illegal user" but 
can be anything that the administrator deems as an undesirable activity.

2) How do I install it?

   Please see the INSTALL.TXT file which should accompany the distribution

3) Where can I get the latest details and stuff?

   See http://www.pettingers.org/code/sshblack.html or http://sshblack.com

4) Do I need superuser privileges?

   Yes.  Because the script modifies iptables, you will need to have root 
privileges on the host.  Commonly the security log files that sshblack monitors 
are also privileged files.

5) What is the white-list and what do I need to do to set it up?

   The white-list is one of the most important aspects of the script.  It should 
be configured even if nothing else is changed from the default configuration.  
The whitelist is a list of hosts and/or networks that will NEVER be blacklisted, 
even if they attack the protected host in such a way that they would normally 
get blacklisted.  The list is formulated with a regular expression (REGEX) and a 
complete tutorial on REGEX is beyond the scope of this document but hopefully 
this will help:
   Let's take a look at our whitelist string from the default code. Remember, 
any address that shows up in this whitelist will effectively be ignored by the 
script.

my($LOCALNET) = '^(?:127\.0\.0\.1|192\.168\.0)';

   What that tells us is that we are going to trust all those IP addresses that 
come from 127.0.0.1 and 192.168.0. We know 127.0.0.1 is the address reserved for 
localhost. That is, this address is ourself. But wait. 192.168.0 is only three 
numbers! IPv4 requires four numbers/octets/tuples.
True, but when we parse, we can use a subset of that for our filter. So all we 
are saying is that we are going to trust anything that has AT LEAST those three 
numbers in the IP address. So 192.168.0.1 is fine, 192.168.0.254 is fine and so 
is everything in between. It's a wildcard for the 192.168.0.0/24 network.

   What about that vertical bar, the pipe character? The pipe | is treated as an 
"or" in this REGEX. That's pretty much all you need to know about it. You can 
use as many of these as you need.

   The backslashes are there to tell Perl that the dots are literal dots. Dots 
normally mean something else in Perl and in REGEX generally so, although it is 
visually confusing, you need the backslashes.  The caret symbol ^ is used to 
anchor the search the start of the line.  This allows us to match 192.168.0.x 
but won't match x.192.168.0

   So lets do an example with some other (fictional) addresses.

   Say the machine I'm trying to protect is at 220.50.50.1
   Let's say my machine sits on a Class C network with other machines that I 
trust implicitly. That network is going to be 220.50.50.0/24 or 
220.50.50.0/255.255.255.0 or however you want to note it. But remember, the 
sshblack script doesn't think of these addresses as IP addresses, it is looking 
at them as a string, as text. So we only need the first three numbers -- we are 
ignoring or wild-carding the last number.
   So this REGEX is going to become 220\.50\.50

   Let's also say that we want to make sure we don't blacklist ourselves as we 
log in from our office address which resides on the other side of town on a 
fixed IP of 66.249.64.68 but I don't trust anyone around that address so I'm not 
going to wildcard anything there.
   This REGEX becomes 66\.249\.64\.68

   Now let's put all this together for our whitelist ($LOCALNET) definition.

   my($LOCALNET) = '^(?:127\.0\.0\.1|220\.50\.50|66\.249\.64\.68)';

   Note I've used the pipe character (|) between all my entries and I didn't 
forget that pesky semi-colon at the end of the line.

   Hope this helps some folks. The whitelisting function is pretty important.

6) How do I integrate this with my iptables configuration?

   It has become obvious that there are dozens of common "firewall" scripts 
being used out there and an infinite number of existing iptables configurations.  
See the INSTALL.TXT file for a complete discussion of this.  You might also look 
at http://www.pettingers.org/firewall.html for some thoughts on a simple set-up.  
Certainly you can choose to have the script add it's "-j DROP" or "-j REJECT" 
jumps directly to the INPUT chain and you will not be required to modify your 
iptables configuration (assuming you have the script install these jumps in the 
right order in your INPUT chain).  Actually, this should work even for a virgin 
iptables configuration.  However, it makes things a bit neater if you set up a 
custom chain for the blacklist.  Simply, the vision for how this script would 
work with such a custom iptables chain is as follows.

	a) Packets will enter the INPUT chain.  Here they will pass through 
whatever existing chains and filters are currently set up, including accounting 
for things like "state RELATED, ESTABLISHED".  It is assumed that the INPUT 
chain will have a policy (-P) of DROP meaning that everything that falls through
all INPUT rules will be dropped.
	b) Before an SSH packet is finally accepted or dropped/rejected in the 
INPUT chain, it will be passed through the BLACKLIST chain which is created to 
support sshblack.
	c) If an IP is listed in BLACKLIST, it will be dropped.  If it is not 
listed, the packet will RETURN TO THE INPUT CHAIN for further processing.
	d) Back at the input chain, the packet will be processed for acceptance or 
rejection by other chains and/or rules.   If these rules do not explicitly 
accept the packet, it will be dropped.

   It is important to recognize in the discussion above that there must either 
be 1) a rule to explicitly accept the packet after it is passed through the 
BLACKLIST chain and back to INPUT or 2) the INPUT chain must be set to policy 
ACCEPT.  We recommend the former, not the latter.  Firewalls should always be 
designed to IMPLICTLY deny all packets and EXPLICITLY accept certain packets.  
You want to think about what is going to happen to your packets as they pass 
through ALL the chains in your iptables setup and be careful or you will lock 
yourself out.  For example, if you blindly add the BLACKLIST chain but never add 
a rule in the INPUT chain to accept SSH, you will lock out all SSH packets even 
though there are no listings in the BLACKLIST chain.  Again, see INSTALL.TXT for 
more on this if you still have questions.

