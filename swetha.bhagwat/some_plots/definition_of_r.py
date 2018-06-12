import numpy as np
import matplotlib.pyplot as plt
import pylab
from pycbc.waveform import get_td_waveform
from scipy import interpolate
from scipy import constants


import matplotlib
import numpy as np
#matplotlib.use('Agg')
import matplotlib.pyplot as plt 
import pylab as pb
import matplotlib.pylab as pylab

import sys
import numpy
from numpy import loadtxt
from numpy import *
import os
import pylab

from pycbc.waveform import phase_from_polarizations, frequency_from_polarizations, amplitude_from_polarizations

import matplotlib
import numpy as np
#matplotlib.use('Agg')
import matplotlib.pyplot as plt 
import matplotlib.pylab as pylab
params = {'legend.fontsize': 'x-large',
          'figure.figsize': (15, 10),
         'axes.labelsize': 'x-large',
         'axes.titlesize':'x-large',
         'xtick.labelsize':'x-large',
         'ytick.labelsize':'x-large'}
pylab.rcParams.update(params)
csfont = {'fontname':'serif'}

apx = 'SEOBNRv2'
m_sun = 2*(10**30)
m1 = 47.932518
m2 = 36.597004
M = (m1 + m2) * m_sun
s1z=0.96167207
s2z=-0.8996653
dt = 1./16384
flow = 15.
d_eff_h = 970
phase_h = -2.77
t_h = 1126259462.422363281
t_l = 1126259462.415039062
mpar_to_m=3.086* (10**22)

hp, hc = get_td_waveform(approximant=apx,
                         mass1=m1,
                         mass2=m2,
                         spin1z=s1z,
                         spin2z=s2z,
                         delta_t = dt,
                         distance = d_eff_h,
                         coa_phase = phase_h,
                         f_lower=flow)

#hp = hp.trim_zeros()
#hc = hc.trim_zeros()
#phi = np.unwrap(np.arctan2(hc.data, hp.data))
#f = np.diff(phi) * hc.sample_rate / (2 * np.pi)
#t = hc.sample_times[:-1]

amp=amplitude_from_polarizations(hp,hc)
amp=amp[:-1]
f=frequency_from_polarizations(hp,hc)

print size(amp)
print size(f)

red_mass=(m1*m2)*m_sun/(m1+m2)
print constants.c

print constants.G

r_sch = constants.G * M / constants.c**2

#distance=4.*(constants.G**(5./3.))*(M**(2./3.)*red_mass*(f[0]**(2./3.)))/(amp[0]*((constants.c**4)))


distance1=4.*(constants.G**(5./3.))*(M**(2./3.)*red_mass*(np.pi**(2./3.))*(f[100]**(2./3.)))/(amp[100]*((constants.c**4)))
#print distance
print distance1

r=zeros(size(f))
r1=zeros(size(f))
for i in range(size(amp)):
	#rsq=amp[i]*((constants.c**4)*(distance))/(4*constants.G*red_mass*((np.pi*f[i])**2))
	#r[i]=sqrt(rsq)/r_sch
	rsq1=amp[i]*((constants.c**4)*(distance1))/(4*constants.G*red_mass*((np.pi*f[i])**2))
	r1[i]=sqrt(rsq1)/r_sch

separation_km = (constants.G * M / ((np.pi * f)**2))**(1./3) / constants.kilo

separation_sch = separation_km * constants.kilo / r_sch

print size(r)
print size(separation_sch)
print size(f.sample_times)

fig = plt.figure()
ax1 = plt.axes()

ax1.plot(f.sample_times, array(r1),color='tomato',label='$r_{eff}$')

#pylab.plot(f.sample_times, array(r),'r')
###pylab.plot(f.sample_times, separation_sch ,'g',label='r_kepler')


ax1.plot(f.sample_times, separation_sch ,color='darkcyan',label='Keplerian')
ax1.set_xlim([-0.02,0.04])
ax1.set_ylim([0,6])
ax1.axvline(x=0.,color='g', ls= '--')
ax1.grid()
#ax1.xlabel("Time (in s)")
ax1.set_xlabel('Time (in second)',fontsize=32,**csfont)
ax1.set_ylabel('Seperation (in M)',fontsize=32,**csfont)
ax1.legend()
ax1.tick_params(labelsize=14)
fig.savefig('/home/swetha.bhagwat/my_thesis/sugwg_git_repo/thesis/SwethaBhagwat/some_plots/keplerianversusreff.pdf')
plt.show()
