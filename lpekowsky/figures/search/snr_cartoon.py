#!/usr/bin/env python

from random import seed,gauss
from matplotlib import use
use('Agg')
import pylab
import numpy

seed(88)

ts = numpy.arange(0,10,0.1)
ss = ts-6.0
xs = 10*numpy.exp( - 15 * ss * ss )
ss = ts-2.5
xs += 3*numpy.exp( - 3.5 * ss * ss )
xs += [gauss(0,1) for t in ts]
xs += abs(min(xs)) + 0.7
pylab.plot(ts, xs)
pylab.plot(ts, [5.5 for x in ts], '--')

p = 0.8
pylab.text(p,xs[int(p / 0.1)]+0.4, '1')

p = 2.2
pylab.text(p-0.1,xs[int(p / 0.1)]+0.4, '2')

pylab.text(2.3,9.5,'3')
pylab.text(6,12.5,'4')

pylab.ylim(0,13)
pylab.xlabel('Time (sec)')
pylab.ylabel('SNR')
pylab.savefig('snr_cartoon.png')

