#! /usr/bin/env python

import matplotlib
matplotlib.use('Agg')
import numpy as np
from numpy import sqrt, pi,cos, sin,loadtxt, float32,float64, array, append
from scipy.interpolate import interp1d
import gc

import sys
import os
import time
import commands

from optparse import OptionParser

from glue import lal
from glue import gpstime

from glue.ligolw import ligolw
from glue.ligolw import table
from glue.ligolw import lsctables
from glue.ligolw import utils as ligolw_utils
from glue.ligolw.utils import process as ligolw_process
from glue import pidfile as pidfile
from glue import git_version

__author__ = "Prayush Kumar <prkumar@syr.edu>"
PROGRAM_NAME = os.path.abspath(sys.argv[0])

############## Functions ######################
class test:
        #def __init__(self):
                #self.m1 = m1
                #self.m2 = m2
        QM_MTSUN_SI = 4.9254909500000001e-06
        @classmethod
        def m1_m2_to_mchirp_eta( self, m1, m2 ):
                mt = m1 + m2
                et = m1 * m2 / mt**2
                mc = mt * et**0.6
                return (mc, et)
        def m1_m2_to_tau0_tau3( self, m1, m2 ):
                mt = m1 + m2
                et = m1 * m2 / mt**2
                tau3 = 1.0 / (8.0 * ( pi * pi * options.f_min**5.0 )**( 1.0/3.0 ) * mt**( 2.0/3.0 ) * et)
                tau0 = 5.0 / (256.0 * pi*options.f_min**( 8.0/3.0 ) * mt**( 5.0/3.0 ) * et)
                return (tau0, tau3)
        def m1_m2_to_tau0_tau3( self, m1, m2, f_min ):
                mt = m1 + m2
                et = m1 * m2 / mt**2
                tau3 = 1.0 / (8.0 * ( pi * pi * f_min**5.0 )**( 1.0/3.0 ) * mt**( 2.0/3.0 ) * et)
                tau0 = 5.0 / (256.0 * pi * f_min**( 8.0/3.0 ) * mt**( 5.0/3.0 ) * et)
                return (tau0, tau3)
        def mchirp_eta_to_m1_m2( mchirp, eta ):
                mt = mchirp / eta**0.6
                tmp = (mt**2 * (1. - 4.*eta))**0.5
                m1 = (mt + tmp)/2.
                m2 = (mt - tmp)/2.
                return (m1,m2)


qm = test()

def within_region( m1, m2 ):
        eta = m1 * m2 / (m1 + m2)**2
        mc = (m1 + m2) * eta**0.6
        feta = -7011.5 * eta**4 + 5169.4*eta**3 - 1469.6*eta**2 + 217.76*eta + 12.02
        if mc >= feta:
                return True
        else:
                return False

def approx_equal( fq, iq ):
        if abs(float( fq - iq )) < 1.e-4 * fq:
                return True
        else:
                return False


#########################################################################
#################### Input parsing #####################
#########################################################################
#{{{
parser = OptionParser(
    version = git_version.verbose_msg,
    usage = "%prog [OPTIONS]",
    description = "Takes in the iteration id. Reads in bank_id.xml. Writes bank_id_part_pid.xml, where each of these part files have bank-batch-size consecutive elements of the bank_id.xml. pid is part-id.")

parser = OptionParser()
parser.add_option("--input-bank",help="input bank",type=str)
parser.add_option("--output-bank",help="output bank",type=str)
parser.add_option("--mismatch-file",help="file with mismatches for all q, concatenated",type=str)
parser.add_option("--table",help="sngl or sim",default='sim',type=str)

parser.add_option("-C", "--comment", metavar="STRING", help="add the optional STRING as the process:comment", default='' )
parser.add_option("-V", "--verbose", action="store_true", help="print extra debugging information", default=False )

(options, args) = parser.parse_args()
#}}}

if options.input_bank is None or options.output_bank is None or options.mismatch_file is None:
  raise IOError("PLease give input AND output bank names AND the mismatch file")

################### Read in the bank file, and get the sim table ############
bank_file_name = options.input_bank
in_bank_doc = ligolw_utils.load_filename(bank_file_name, options.verbose)
try :
    in_bank_table = table.get_table(in_bank_doc, lsctables.SimInspiralTable.tableName)
except ValueError:
    in_bank_table = table.get_table(in_bank_doc, lsctables.SnglInspiralTable.tableName)

################### Read in the mismatches and interpolate them ############
dat = loadtxt( open(options.mismatch_file, 'r') )
mismatches = []
mass_ratios = array([1,2,3,4,6,8])

for q in mass_ratios:
  # Separate different mass ratios' mismatches
  qmt = array([])
  qmm = array([])
  for tmpm1, tmpm2, tmpmm in dat:
    tmpq = max(tmpm1, tmpm2) / min(tmpm1, tmpm2)
    if approx_equal( tmpq, q ):
      qmt = append(qmt, tmpm1 + tmpm2 )
      qmm = append(qmm, tmpmm )
  # Sort the totalmass-mismatch arrays according to total mass
  qmt, qmm = (list(x) for x in zip(*sorted(zip(qmt, qmm))))
  fmm = interp1d( qmt, qmm )
  mismatches.append( [qmt, qmm, fmm] )

dicfmm = {}
for idx in range(len(mass_ratios)):
  dicfmm.update({mass_ratios[idx]:mismatches[idx][2]})
  

################### Process the bank amd write it to disk ############
subfile_name = options.output_bank
if options.verbose:
  print "Writing substitute-bank file %s" % subfile_name
out_subbank_doc = ligolw.Document()
out_subbank_doc.appendChild(ligolw.LIGO_LW())
out_proc_id = ligolw_process.register_to_xmldoc(out_subbank_doc,
    PROGRAM_NAME, options.__dict__, comment=options.comment,
    version=git_version.id, cvs_repository=git_version.branch,
    cvs_entry_time=git_version.date).process_id

# Use exactly the same columns as in the input bank table
tmp0 = in_bank_table[0]
cols_list = tmp0.__slots__
cols = []
for tmpc in cols_list:
  if hasattr(tmp0, tmpc):
    cols.append( tmpc )

if options.table == 'sim':
  out_subbank_table = lsctables.New(lsctables.SimInspiralTable,columns=cols)
else:
  out_subbank_table = lsctables.New(lsctables.SnglInspiralTable,columns=cols)

out_subbank_doc.childNodes[0].appendChild(out_subbank_table)

## Logic to compute mismatches and store them in order
for tmplt in in_bank_table:
  tmpq = max(tmplt.mass1,tmplt.mass2)/min(tmplt.mass1,tmplt.mass2)
  for idx in range(len(mass_ratios)):
    q = mass_ratios[idx]
    if approx_equal( q, tmpq ):
      fmm = dicfmm[q]
      break
  tmpM = tmplt.mass1 + tmplt.mass2
  if tmpM < mismatches[idx][0][0]:
    mm = .03
  elif tmpM > mismatches[idx][0][-1]:
    mm = 0.
  else:
    mm = fmm( tmpM )
  tmplt.alpha = mm
  out_subbank_table.append( tmplt )


# Just checking if input and output tables are of equal length
if len(out_subbank_table) != len(in_bank_table):
  raise ValueError("Some templates went missing!")
elif options.verbose:
  print "All %d templates written to output" % len(out_subbank_table)

## Write the output bank
subbank_proctable = table.get_table(out_subbank_doc, lsctables.ProcessTable.tableName)
subbank_proctable[0].end_time = gpstime.GpsSecondsFromPyUTC(time.time())
ligolw_utils.write_filename(out_subbank_doc, subfile_name)

