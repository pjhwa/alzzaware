#!/usr/bin/perl
#
# Make a Red Hat installation floppy set.  Parses the Red Hat image.idx file
# to generate a dialogue to pick a disk image, then makes the disk.  Send
# flames and tossed roses to Eric Raymond, <esr@snark.thyrsus.com>.
#
# Hacked up by Erik Troan, <ewt@redhat.com>. I'll take any flames but keep
# the roses going to esr. I guess this script i just "Eri[ck]'s thing"
#
# Re-hacked by Eric Raymond after RH 2.1.  Don't flame Erik for anything but
# his typos :-), he did good. Erik applied Eric's patch by hand as patch(1)
# was having a bad day, and made the savesetup stuff optional, which he's
# been meaning to do for ages.

# There should probably be some options to override these
$cddir="..";			     # Can be overwritten by $ARGV[0]

# Note: we skip the verify because (on my Linux, anyway) it's prone
# to issuing "unknown read error" messages on floppies that seem OK.
+$format="fdformat /dev/fd0H1440";	# How to format a floppy

sub pick_one {
# Pick one choice from a list of alternatives
    local ($legend, @alternatives) = @_;

    while (1)
    {
	print "$legend:\n";
	$num = 0;
	foreach $x (@alternatives)
	{
	    print "    ", $num++, ") $x\n";
	}

	print "Pick one: ";
	$response = <STDIN>;
	chop $response;

	if ($response =~ /[0-9]+/ && $response >= 0 && $response <= $num)
	{
	    print "\n";
	    return $alternatives[$response]
	}

	print "Sorry, that didn't look like a valid response.\n\n"
    }
}

sub copy_image {
# Copy a given image to the boot device, offering to do a format first
    local($name, $imagefile) = @_;

    print "\n";

    # Verify that the desired image is accessible
    if (! -r "$imagefile" && ! -r "$imagefile.gz")
    {
	print "I can't find $imagefile to read it.\n";
	print "This may mean that your CD-ROM is not mounted,\n";
	print "or that you lack the necessary read permissions,\n";
	print "or that your Linux uses a different mount point for\n";
	print "the CD-ROM than I am expecting.\n";
	return;
    }

    # Offer to format the disk.
    print "About to make $name disk.\n";

    dformat: {
	print "Please insert your disk in your boot floppy drive.\n";
	print "If you answer `y' to this prompt, it will be formatted first [yn]: ";
	if (<STDIN> =~ '^[yY]')
	{
	    system($format);

	    print "\nIf the format issued any suspicious messages,\n";
	    print "you can try formatting another disk.\n\n";
	    print "Did the format look OK [yn]? ";
	    redo dformat if (<STDIN> !~ '^[yY]');
	}
	else
	{
	    print "Format skipped.\n";
	}


	print "\n";
    }

    # Now dd the chosen image to it
    print "Copying the image...\n";
    if ( -r $imagefile ){
	$status = system("dd if=$imagefile of=$bootdev bs=64k");
    } elsif ( -r "$imagefile.gz" ) {
	$status = system("gunzip < $imagefile.gz | dd of=$bootdev");
    }
    if ($status == 0) {
	print "Copy succeeded (status 0).\n";
    } else {
	print "Copy failed (status $status).\n";
    }
}

sub make_bootdisk {
# Ask the user for his/her configuration and make an appropriate boot disk
    open(IMAGES, "$imagedir/image.idx") || die("Can't find images file.\n");

    # Build lists of the possible alternatives
    while (<IMAGES>)
    {
	chop;
	($image, $scsi, $ethernet, $cdrom) = split(/; /);

	foreach $x (split(/, /, $scsi)) {
	    push(@scsi_types, $x) if $scsi_seen{$x}++ == 0;
	}

	foreach $x (split(/, /, $ethernet)) {
	    push(@ethernet_types, $x) if $ethernet_seen{$x}++ == 0;
	}

	foreach $x (split(/, /, $cdrom)) {
	    push(@cdrom_types, $x) if $cdrom_seen{$x}++ == 0;
	}
   }
   seek(IMAGES, 0, 0);

   print "\n";

   # Get the user's responses on his or her configuration
   hardware: {
	print "Please pick the menu choices describing your hardware.\n\n";

	$scsi_choice     = &pick_one("SCSI support", @scsi_types);
	$ethernet_choice = &pick_one("Ethernet support", @ethernet_types);
	$cdrom_choice    = &pick_one("CD-ROM support", @cdrom_types);

	# Feedback
	print "Here's what you selected:\n";
	print "    SCSI: $scsi_choice\n";
	print "    Ethernet: $ethernet_choice\n";
	print "    CD-ROM: $cdrom_choice\n";
	print "\n";

	print "Is this correct [yn]? ";
	redo hardware if (<STDIN> !~ '^[yY]');
	print "\n";
    }

    # OK, now build the set of image alternatives
    while (<IMAGES>)
    {
	chop;
	($image, $scsi, $ethernet, $cdrom) = split(/; /);

	if ((index($scsi, $scsi_choice) != -1)
	    && (index($ethernet, $ethernet_choice) != -1)
	    && (index($cdrom, $cdrom_choice) != -1))
	{
	    push(@imagelist, "$image: $scsi; $ethernet; $cdrom");
	}
    }

    # Find the images that match the spec the user set up
    image: {
	$image = &pick_one("Here are the images that match", @imagelist);

	# Feedback
	($imageno, $rest) = split(/:/, $image);
	print "You selected image $imageno\n";

	$imagefile = "$imagedir/boot${imageno}.img";
	print "Make a boot disk from $imagefile [yn]? ";
	redo image if (<STDIN> !~ '^[yY]');
    }
    close(IMAGES);

    # Actually make the disk
    &copy_image("boot", $imagefile);

    print "Do you want to save the setup of this machine on the new bootdisk [yn]? ";
    if (<STDIN> =~ '[yY]') {
	# Now mount it and run our "savesetup" script
	system("mkdir -p /tmp/floppy");
	system("mount -t umsdos /dev/fd0 /tmp/floppy");
	print "Saving system configuration info...";
	system("./savesetup.pl /tmp/floppy");
	system("umount /tmp/floppy");
	print "\n";
    }
}

if ( @ARGV == 1 ) {
    $cddir = $ARGV[0];
}

$sysdir="$cddir/images";           	# Root/rescue image directory
$imagedir="${sysdir}/1213";		# Boot images directory
$bootdev="/dev/fd0";			# Where to make the floppy

if ( @ARGV > 1 ) {
    print STDERR "usage:\n";
    print STDERR "\t$0 <path to Red Hat CD>\n";
    print STDERR;
    exit 1;
}

# Check $cddir for correctness
if ( ! -e "$cddir/RedHat" ) {
    print STDERR "$cddir isn't the path to your Red Hat CD. Run this script\n";
    print STDERR "with the path to your Red Hat CD as it's sole argument\n";
    print STDERR;
    exit 1;
}

# Main sequence
print "mkfloppies.pl 1.2 - Copyright 1995 Eric Raymond, Red Hat Software\n";
print "This may be freely redistributed under the terms of the GNU Public License\n\n";

print "This script will help you create an installation set for your\n";
print "Red Hat distribution: boot, root, and rescue floppies.  To use it,\n";
print "you should have a 3.5-inch 1.44K floppy drive as your boot device\n";
print "(which is normal) and have at least three 1.44K floppies ready (four\n";
print "if you want to make a rescue disk, which we recommend).  This script\n";
print "can format the floppies for you.\n\n";

print 'Do you want to make a boot disk [yn]? ';
&make_bootdisk if (<STDIN> =~ '[yY]');
print "\n";

print 'Do you want to make your #1 root disk [yn]? ';
&copy_image("root 1", "${sysdir}/ramdisk1.img") if (<STDIN> =~ '[yY]');
print "\n";

print 'Do you want to make your #2 root disk [yn]? ';
&copy_image("root 2", "${sysdir}/ramdisk2.img") if (<STDIN> =~ '[yY]');
print "\n";

print 'Do you want to make a rescue disk [yn]? ';
&copy_image("rescue", "${sysdir}/rescue.img") if (<STDIN> =~ '[yY]');
print "\n";

print "Your floppies should now be ready to be used for system installation.\n"

# script ends here
