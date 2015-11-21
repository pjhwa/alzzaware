These are 1.44 MB bootkernel images for Slackware Linux 3.1.0. (Slackware96)

These disks currently use Linux 2.0.0.

You'll need one of these to get Linux started on your system so that you can
install it. Because of the possibility of collisions between the various Linux
drivers, several bootkernel disks have been provided. You should use the one
with the least drivers possible to maximize your chances of success. All of
these disks support UMSDOS.

You will be using the bootkernel disk to boot a root-install disk. See the
/rootdsks directory for these.

A bootkernel disk is created by writing the image to a formatted floppy disk
with RAWRITE.EXE under DOS.  For example, to use RAWRITE.EXE to create the
bare.i bootdisk you'd put a formatted disk in your floppy drive and issue
the following command:

C:\> RAWRITE BARE.I A:

--------------------------------------------------------------------------------

Here's a description of the disks:

 IDE bootdisks:     (All IDE bootdisks support IDE hard drives and CD-ROM
                     drives, plus additional support listed below)
 --------------

    aztech.i           CD-ROM drives:  Aztech CDA268-01A, Orchid CD-3110,
                       Okano/Wearnes CDD110, Conrad TXC, CyCDROM CR520, CR540.

    bare.i             (none, just IDE support)

    cdu31a.i           Sony CDU31/33a CD-ROM.

    cdu535.i           Sony CDU531/535 CD-ROM.

    cm206.i            Philips/LMS cm206 CD-ROM with cm260 adapter card.

    goldstar.i         Goldstar R420 CD-ROM (sometimes sold in a 'Reveal
                       Multimedia Kit').

    mcd.i              NON-IDE Mitsumi CD-ROM support.

    mcdx.i             Improved NON-IDE Mitsumi CD-ROM support.

    net.i              Ethernet support.

    optics.i           Optics Storage 8000 AT CD-ROM (the 'DOLPHIN' drive).

    sanyo.i            Sanyo CDR-H94A CD-ROM support.

    sbpcd.i            Matsushita, Kotobuki, Panasonic, CreativeLabs 
                       (Sound Blaster), Longshine and Teac NON-IDE CD-ROM
                       support.

    xt.i               MFM hard drive support.


  SCSI bootdisks:    (All SCSI bootdisks feature full IDE hard drive and
                     CD-ROM drive support, plus additional drivers listed
                     below)
  ---------------

    7000fast.s         Western Digital 7000FASST SCSI support.

    advansys.s         AdvanSys SCSI support.

    aha152x.s          Adaptec 152x SCSI support.

    aha1542.s          Adaptec 1542 SCSI support.

    aha1740.s          Adaptec 1740 SCSI support.

    aha2x4x.s          Adaptec AIC7xxx SCSI support.  
                       (For these cards: AHA-274x, AHA-2842, AHA-2940, 
                       AHA-2940W, AHA-2940U, AHA-2940UW, AHA-2944D, AHA-2944WD,
                       AHA-3940, AHA-3940W, AHA-3985, AHA-3985W)

    am53c974.s         AMD AM53/79C974 SCSI support.

    aztech.s           All supported SCSI controllers, plus CD-ROM support for
                       Aztech CDA268-01A, Orchid CD-3110, Okano/Wearnes CDD110,
                       Conrad TXC, CyCDROM CR520, CR540.

    buslogic.s         Buslogic MultiMaster SCSI support.

    cdu31a.s           All supported SCSI controllers, plus CD-ROM support for
                       Sony CDU31/33a.

    cdu535.s           All supported SCSI controllers, plus CD-ROM support for
                       Sony CDU531/535.

    cm206.s            All supported SCSI controllers, plus Philips/LMS cm206
                       CD-ROM with cm260 adapter card.

    dtc3280.s          DTC (Data Technology Corp) 3180/3280 SCSI support.

    eata_dma.s         DPT EATA-DMA SCSI support.  (Boards such as PM2011, 
                       PM2021, PM2041, PM3021, PM2012B, PM2022, PM2122, PM2322,
                       PM2042, PM3122, PM3222, PM3332, PM2024, PM2124, PM2044, 
                       PM2144, PM3224, PM3334.)

    eata_isa.s         DPT EATA-ISA/EISA SCSI support.  (Boards such as 
                       PM2011B/9X, PM2021A/9X, PM2012A, PM2012B, PM2022A/9X,
                       PM2122A/9X, PM2322A/9X)

    eata_pio.s         DPT EATA-PIO SCSI support.  (PM2001 and PM2012A)

    fdomain.s          Future Domain TMC-16x0 SCSI support.

    goldstar.s         All supported SCSI controllers, plus Goldstar R420
                       CD-ROM (sometimes sold in a 'Reveal Multimedia Kit').

    in2000.s           Always IN2000 SCSI support.

    iomega.s           IOMEGA PPA3 parallel port SCSI support.  (also supports
                       the parallel port version of the ZIP drive)

    mcd.s              All supported SCSI controllers, plus standard non-IDE
                       Mitsumi CD-ROM support.

    mcdx.s             All supported SCSI controllers, plus enhanced non-IDE
                       Mitsumi CD-ROM support.

    n53c406a.s         NCR 53c406a SCSI support.

    n_5380.s           NCR 5380 and 53c400 SCSI support.

    n_53c7xx.s         NCR 53c7xx, 53c8xx SCSI support.  (Most NCR PCI
                       SCSI controllers use this driver)

    optics.s           All supported SCSI controllers, plus support for the 
                       Optics Storage 8000 AT CD-ROM (the 'DOLPHIN' drive).

    pas16.s            Pro Audio Spectrum/Studio 16 SCSI support.

    qlog_fas.s         ISA/VLB/PCMCIA Qlogic FastSCSI! support.  (also 
                       supports the Control Concepts SCSI cards based on the
                       Qlogic FASXXX chip)

    qlog_isp.s         Supports all Qlogic PCI SCSI controllers, except the
                       PCI-basic, which is supported by the AMD SCSI driver.

    sanyo.s            All supported SCSI controllers, plus Sanyo CDR-H94A
                       CD-ROM support.

    sbpcd.s            All supported SCSI controllers, plus Matsushita, 
                       Kotobuki, Panasonic, CreativeLabs (Sound Blaster), 
                       Longshine and Teac NON-IDE CD-ROM support.

    scsi.s             A generic SCSI bootdisk, with support for most SCSI
                       controllers that work under Linux.  (NOTE: This disk
                       wastes a lot of memory, since it contains nearly *all*
                       of the SCSI drivers.  If you know which SCSI controller
                       your system has, it's *far* better to use the disk 
                       designed especially for it.  But, if you don't know,
                       then this generic disk might just work for you.)

    scsinet.s          All supported SCSI controllers, plus full ethernet
                       support.

    seagate.s          Seagate ST01/ST02, Future Domain TMC-885/950 SCSI
                       support.

    trantor.s          Trantor T128/T128F/T228 SCSI support.

    ultrastr.s         UltraStor 14F, 24F, and 34F SCSI support.

    ustor14f.s         UltraStor 14F and 34F SCSI support.

---------------------------------------------------------------------------------
IMPORTANT HELPFUL HINTS: (AND WHAT TO DO IF THE INSTALLED SYSTEM WON'T BOOT)

The kernels provided with the Slackware A series (ide and scsi) are reasonably 
generic to maximize the chances that your system will boot after installation. 
However, you should compile a custom kernel after installing, selecting only the
drivers your system requires.  This will offer optimal performance.  You'll need
to recompile your kernel to enable support for non-SCSI CD-ROM drives, bus-mice,
sound cards, and many other pieces of hardware.  The drivers could not be 
included with the pre-compiled kernels because they cause system hangs and other
compatiblity problems for people that don't have the hardware installed.

On a similar note, any time you use one kernel to install, and a different 
kernel the first time the installed system is started, you run the risk that
the second kernel won't be compatible for some reason. If your system fails
to reboot after installation, you'll have to compile a custom kernel for your
hardware. Follow these steps:

0. If you haven't installed the C compiler and kernel source, do that.

1. Use the bootkernel disk you installed with to start your machine. At the LILO
   prompt, enter: 
   
     mount root=/dev/hda1
                ^^^^^^^^^ Or whatever your root Linux partition is.

   Ignore any error messages as the system starts up.

2. Log in as root, and recompile the kernel with these steps. (Comments will be
   placed in parenthesis) 

   cd /usr/src/linux
   make config   (Choose your drivers. Repeat this step until you are satisfied
                  with your choices)
   
   If you are using LILO, this will build and install the new kernel:

     make dep ; make clean ; make zlilo 
     rdev -R /vmlinuz 1

   If you are using a bootdisk, these commands will build the kernel and create
   a new bootdisk for your machine:

     make dep ; make clean ; make zImage
     rdev -R zImage 1    (If you use UMSDOS for your root partition, use
                          'rdev -R zImage 0' instead)
     rdev -v zImage -1
     rdev zImage /dev/hda1   (replace /dev/hda1 with the name of your root Linux
                              partition)
     (Now, put a disk into your floppy drive to be made into the new bootdisk:)
     fdformat /dev/fd0u1440 
     cat zImage > /dev/fd0

That should do it! You should now have a Linux kernel that can make full use of
all supported hardware installed in your machine. Reboot and try it out.

Good luck!

---
Patrick Volkerding
volkerdi@mhd1.moorhead.msus.edu

PS - Bug reports welcome. Requests for help may be answered if time permits.
     I've been happy to do this in the past, but lately I've had both a lot 
     more work to do and a lot more mail to deal with. It's just not as possible
     to keep up with my mail as it once was.
