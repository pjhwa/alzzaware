#!/usr/bin/perl

if (@ARGV) {
    $path = $ARGV[0];
} else {
    $path = "/mnt/floppy"
}

# check the file paths
((-d "$path/startup") && (-f "$path/vmlinuz")) ||
    die("$path doesn't appear to have a boot disk mounted there");

# if the defaults directory doesn't exist, create if
if (! (-d "$path/defaults")) {
    mkdir("$path/defaults", 755) || 
	die("I couldn't create $path/defaults for some reason");
}

# first grab the fstab

open(FSTAB, "/etc/fstab") || die("I can't open /etc/fstab");

open(OUTFSTAB, ">$path/defaults/fstab") ||
    die("I can't create a new $path/defaults/fstab");

# this remembers ext2, msdos, and hpfs partitions only -- the rest get trashed
# the options aren't saved either, which may be bad (what if /dos is mounted
# ro)

while (<FSTAB>) {
    s/#.*//;
    s/^[ \t]+//;
    s/[ \t]+$//;
    s/[ \t]+/ /;

    if (($device, $mntpoint, $type, $options) =
	/^([^ ]*) ([^ ]*) ([^ ]*) (.*)$/) {
	next if ($device =~ m,/dev/fd,);
	if ($type eq "ext2" || $type eq "msdos" || $type eq "hpfs") {
	    print OUTFSTAB "$device $mntpoint $type\n";
	    print "$device is mounted at $mntpoint\n";
	}    
    }
}
close(FSTAB);
close(OUTFSTAB);

print "\n";

# now grab the networking stuff

open(IFCONFIG, "/sbin/ifconfig eth0 2>/dev/null|") ||
    die("I can't read from /sbin/ifconfig eth0");

while (<IFCONFIG>) {
    if (/inet addr/) {
	($addr, $bcast, $mask) =
            /inet addr[: ]([0-9\.]+) *Bcast[: ]([0-9\.]+) *Mask[: ]([0-9\.]+)/;
	    # The above regexp from Lewis Perin <perin@ritz.mordor.com>
            #/inet addr:([0-9\.]+) *Bcast:([0-9\.]+) *Mask:([0-9\.]+)/;
            #inet addr:199.183.24.4  Bcast:199.183.24.255  Mask:255.255.255.0
    }
}

close(IFCONFIG);

if (! defined $addr) {
    print "You don't have any networking setup for eth0. If you use PPP or\n";
    print "SLIP, be sure to back up your setup scripts before installing\n";
    print "Red Hat.\n\n";
} else {
    print "It looks like your ip address is $addr\n";
    print "It looks like your broadcast address is $bcast\n";
    print "It looks like your net mask is $mask\n";

    # get the hostname and domain
    open(HOSTNAME, "/bin/uname -n|") || die("I can't read from /bin/uname -n");
    $_ = <HOSTNAME>;
    chop($_);
    close HOSTNAME;

    ($name, $domain) = /([^\.]+)\.(.*)/;
    if (! $name) {
	# uname did not return the FQDN
	$name = $_;
	# The following if() is from Arnt Gulbrandsen <agulbra@troll.no>
	if ( open( HOSTS, "< /etc/hosts" ) ) {
	    while ( <HOSTS> ) {
		s/\#.*//;
		$domain = $1 if ( /\b$name\.([-a-zA-Z0-9\.]+)\b/ );
	    }
	    close HOSTS;
	}
    }


    # grab the default gateway

    $gw = "none";
    open(ROUTES, "/sbin/route -n|") || die("I can't read from /sbin/route\n");

    while (<ROUTES>) {
        if (/^default/) {
	    s/#.*//;
	    s/^[ \t]+//;
	    s/[ \t]+$//;
	    s/[ \t]+/ /;
	    
	    ($a, $gw) = /([^ ]+) *([^ ]+)/;
	}
    }

    if ($gw eq "*") {
	$gw = $addr;
    }

    close(ROUTES);

    print "Your gateway is $gw\n";

#    if (defined($gw) && !($gw =~ /^[0-9]/)) {
#	open(HOST, "/usr/bin/host $gw|") ||
#    die("I can't read from /usr/bin/host $gw\n");
#	while (<HOST>) {
#	    if (/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/) {
#		($gw) = /([0-9]+\.[0-9]+\.[0-9]+\.[0-9])/;
#	    }
#	}
#	close(HOST);
#    }

    # read nameservers
    if (open (RESOLV, "</etc/resolv.conf")) {
        s/#.*//;
	s/^[ \t]+//;
	s/[ \t]+$//;
	s/[ \t]+/ /;
	while (<RESOLV>) {
	    if (! $domain) {
		if (/^domain/) {
		    ($domain) = /\S+\s+(\S+)/;
		}
	    }
	    if (/^nameserver/) {
		($ns) = /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/;
		push(@ns, "\"$ns\"");
		print "You're using $ns as a nameserver\n";
	    }
	}
    }

    # We should now have the hostname and domainname
    print "Your hostname is $name and domain is $domain\n";

    open(NETWORK, ">$path/defaults/network") ||
	die("I can't create a new $path/defaults/network");

    print NETWORK "\$ipaddr=\"$addr\";\n";
    print NETWORK "\$broadcast=\"$bcast\";\n";
    print NETWORK "\$netmask=\"$mask\";\n";
    ($a, $b, $c, $d) = split(/\./, $addr);
    ($am, $bm, $cm, $dm) = split(/\./, $mask);
    $network = sprintf("%d.%d.%d.%d", int($a) & int($am), int($b) & int($bm),
		       int($c) & int($cm), int($d) & int($dm));
    print NETWORK "\$network=\"$network\";\n";

    print "It looks like your network is $network\n";

    print NETWORK "\$hostname=\"$name\";\n";
    print NETWORK "\$domainname=\"$domain\";\n";
    print NETWORK "\$fqdn=\"$name.$domain\";\n";

    print NETWORK "\$gateway=\"$gw\";\n";

    if (defined @ns) {
	printf(NETWORK "\@nslist = (%s);\n",  join(", ", @ns));
    }

    print NETWORK "\$iface=\"eth0\";\n";
    print NETWORK "\n1;\n";

    close NETWORK;
}

if ( -f "/etc/XF86Config" ) {
    $config = "/etc/XF86Config";
} elsif ( -f "/etc/X11/XF86Config") {
    $config = "/etc/X11/XF86Config";
} elsif ( -f "/usr/lib/X11/XF86Config") {
    $config = "/usr/lib/X11/XF86Config";
}

if (defined $config) {
    print "Saving $config\n";
    open(IN, "<$config") || die("cannot open $config");
    open(OUT, ">$path/defaults/XF86Config") ||
	die("cannot open $path/defaults/XF86Config");
    while (<IN>) {
	s&usr/X11/&usr/X11R6/&;
	s&usr/X386/&usr/X11R6/&;
	print OUT;
    }
    close IN.
    close OUT;
}

$xserver = "X";
chdir("/usr/bin/X11");
while (-l $xserver) {
    $what = readlink($xserver);
    if (($dir, $xserver) = ($what =~ /(.+)\/(.*)/)) {
        chdir($dir);
    } else {
	$xserver = $what;
    }
}

if ($xserver =~ /^XF86_/) {
    print "It looks like $xserver is your X server\n";
    ($type) = ($xserver =~ /XF86_(.*)/);
}

open(XSETUP, ">$path/defaults/xsetup") ||
    die("I can't create a new $path/defaults/xsetup");

print XSETUP "\$xserver = \"$type\";\n";

if (-l "/dev/mouse") {
    $mouseport = readlink("/dev/mouse");
    print "Your /dev/mouse is a link to $mouseport\n";
    print XSETUP "\$mouseport = \"$mouseport\";\n";
}    

print XSETUP "\n1;\n";
close XSETUP;

