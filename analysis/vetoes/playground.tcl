#!/usr/bin/env tclshexe
package require segments

#-- Read segment lists
set playfile s2_playground_slices.txt
set anafile s2_analyzed_times.txt
set playsegs [SegRead $playfile]
set anasegs [SegRead $anafile]

#-- Find intersection
set anaplaysegs [SegCoalesce [SegIntersection $anasegs $playsegs] ]

#-- Write out segment file
set fid [open S2L1_macho_playsegs.txt w]
foreach seg $anaplaysegs {
   foreach {start stop} $seg break
      puts $fid "$start $stop"
   }
close $fid
