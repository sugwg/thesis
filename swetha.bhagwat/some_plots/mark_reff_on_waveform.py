import numpy as np
import matplotlib.pyplot as plt
import pylab
from pycbc.waveform import get_td_waveform
from scipy import interpolate
from scipy import constants


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
#m1 = 47.932518
#m2 = 36.597004
m1=47.9
m2=36.6
M = (m1 + m2) * m_sun
s1z=0.96
s2z=-0.89
#s1z=0.96167207
#s2z=-0.8996653
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
eta=(m1*m2)/((m1+m2)**2)
M_final=m_sun*(m1+m2)*(1.+ (((8./9.)**(1./2.0) -1)*eta -(0.4333*(eta**2)) -(0.4392*(eta**3))))

print "M_final:"
print M_final
print "mass in solar units"

R_schFinal=2*constants.G*M_final/(constants.c**2)
print "R_schFinal:"
print R_schFinal

print constants.c

print constants.G

r_sch = constants.G * M / constants.c**2

print r_sch

print "in sch rad:"
print R_schFinal/r_sch
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
	r[i]=sqrt(rsq1)/r_sch


separation_km = (constants.G * M / ((np.pi * f)**2))**(1./3) / constants.kilo

separation_sch = separation_km * constants.kilo / r_sch

print "mu:"
print red_mass
print r[10]*r_sch
print (r[10]*r_sch)**2

newfilename='r_eff.dat'
numpy.savetxt(newfilename, numpy.array([f.sample_times,r]).T)

print size(r)
print size(separation_sch)
print size(f.sample_times)

ex=zeros(size(f.sample_times))
delta=zeros(size(f.sample_times))
for i in range(size(f.sample_times)):
	ex[i]=5*red_mass*r[i]*r[i]*r_sch*r_sch/M_final
	delta[i]=ex[i]/(R_schFinal**2)

for i in range(size(f.sample_times)):
     if r[i]>0.5 and r[i]<0.6:
          r0p5=f.sample_times[i]
     elif r[i]>1. and r[i]<1.1:
          r1m=f.sample_times[i]
     elif r[i]>1.5 and r[i]<1.6:
          r1p5=f.sample_times[i]
     elif r[i]>2. and r[i]<2.1:
          r2=f.sample_times[i]
     elif r[i]>2.5 and r[i]<2.6:
          r2p5=f.sample_times[i]
     elif r[i]>3 and r[i]<3.1:
          r3=f.sample_times[i]
     elif r[i]>3.5 and r[i]<3.6:
          r3p5=f.sample_times[i]
     elif r[i]>4.5 and r[i]<4.6:
          r4p5=f.sample_times[i]
     elif r[i]>4.0 and r[i]<4.01:
          r4=f.sample_times[i]
     elif r[i]>5.5 and r[i]<5.6:
          r5p5=f.sample_times[i]
     elif r[i]>5.0 and r[i]<5.1:
          r5=f.sample_times[i]
print "threshold :"
print( (constants.G*M_final)/((constants.c**6)*distance1))


fig = plt.figure()
ax1 = plt.axes()

ax1.plot(hp.sample_times,hp,color='g',lw=3)
ax1.plot(hc.sample_times,hc,color='tomato',lw=1,ls='--')
ax1.axvline(r0p5,color='m', linestyle='-',label='0.5 M', lw=2 )
ax1.axvline(r1m,color='r', linestyle='-',label='1 M', lw=2 )
ax1.axvline(r1p5,color='g', linestyle='-',label= '1.5 M', lw=2)
ax1.axvline(r2,color='k', linestyle='-',label= '2 M', lw=2)
ax1.axvline(r2p5,color='r', linestyle='--',label='2.5 M' , lw=2)
ax1.axvline(r3,color='k', linestyle='--',label='3 M', lw=2 )
ax1.axvline(r3p5,color='b', linestyle='--',label='3.5 M', lw=2)
ax1.axvline(r4,color='m', linestyle='--',label='4 M', lw=2 )
ax1.axvline(r4p5,color='c', linestyle='--',label='4.5 M' , lw=2)
ax1.axvline(r5,color='g', linestyle='--',label= '5 M', lw=2)
ax1.axvline(r5p5,color='y', linestyle='--',label= '5.5 M', lw=2 )
ax1.set_xlim([-0.02,0.04])
ax1.set_xlabel('Time (in second)',fontsize=32,**csfont)
ax1.set_ylabel('Strain',fontsize=32,**csfont)
plt.legend()
ax1.tick_params(labelsize=14)
fig.savefig('/home/swetha.bhagwat/my_thesis/sugwg_git_repo/thesis/SwethaBhagwat/some_plots/reffmarking.pdf')
plt.show()
