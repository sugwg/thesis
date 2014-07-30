
import sys
import numpy as np

kb = 1.381e-23
E = 3.378e9
rho = 2.2e3
T = 295.0

for arg in sys.argv:
  if arg == 'tnoisecone':
    freq = np.logspace(1.0,6.0,num=1001)
    omega = 2*np.pi*freq
    M = 5.0e-4
    R = 1.0e-3
    lz = 2.0e-3
    t = 1.0e-4
    phi = 0.03
    m = np.pi/3.0*R*R*lz*rho
    mt = M+3.0*m
    rcm = lz/4.0
    mrcm = 3.0*m*rcm
    K0 = 3.0*np.pi*E*R*R*R*R/4.0/t
    It = abs(m/5.0*(3.0/4.0*R*R-2.0*lz*lz))
    Sxx = 4.0*kb*T*K0*phi*mrcm*mrcm/omega
    Sxx = Sxx/np.square(mt*K0*(1.0+phi)+omega*omega*(mrcm*mrcm-mt*It))
    Sx = np.sqrt(Sxx)
    f = open('tnoisecone.dat','w')
    for x,y in zip(freq,Sx):
      f.write('%e    %e\n' % (x,y))
    f.close()
