#!/usr/bin/env tclshexe

set ifolist [list L1]

set winlist [list {-5,2} {-10,2} {-16,2}]
set snrlist [list 7 8 9 10]

foreach ifo $ifolist {
    set cfile ${ifo}-INSPIRAL_PLG.xml
    set rfile S2${ifo}_macho_playsegs.txt

    #-- Construct list of veto files
    set dir /scratch/duncan/macho/2004052501_vetoes/2004051103_l1_playground/$ifo
    set vfiles [lsort -dictionary [concat \
	[glob -nocomplain $dir/${ifo}*-FINAL6.xml] \
	[glob -nocomplain ${ifo}:*-FINAL6.xml] \
	] ]

    #-- Sort veto files based on tail of filename
    set templist [list]
    foreach vfile $vfiles {
	lappend templist [list $vfile [file tail $vfile]]
    }
    set vfiles [lsort -dictionary -index 1 $templist]

    foreach vfileset $vfiles {
	set vfile [lindex $vfileset 0]
	puts "\nVeto file: $vfile"
	puts -nonewline "              "
	foreach snr $snrlist {
	    puts -nonewline [format "       SNR>%-2d  " $snr]
	}
	puts ""
	puts -nonewline "Window   Dead%"
	foreach snr $snrlist {
	    puts -nonewline "    effic  used"
	}
	puts ""

	foreach win $winlist {
	    puts -nonewline [format %-7s $win]

	    set isnr 0
	    foreach snr $snrlist {
		incr isnr
		set da [exec ./lalapps_ivana $cfile "$vfile\($win\)" -s $snr -r $rfile 2>/dev/null ]
		regexp {Total[^\%]+ ([\d\.]+)\%.+ ([\d\.]+)\%.+\% +([\d\.]+)\%} \
		    $da match used effi deadpct
		
		if { $isnr == 1 } {
		    puts -nonewline [format %6.1f $deadpct]
		}
		puts -nonewline [format "   %6.1f%6.1f" $effi $used]
		flush stdout
	    }
	    puts ""
	}
    }

}
