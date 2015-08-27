import pycbc.psd, numpy, pylab, pycbc.filter, pycbc.waveform
from pycbc.fft.fftw import set_measure_level
set_measure_level(0)

def d(f):
    return pycbc.waveform.spa_tmplt.spa_length_in_time(mass1=1.4, mass2=1.4, f_lower=f, phase_order=7)

pylab.rcParams.update({
    "text.usetex": True,
    "figure.figsize": [8.0, 6.0],
    "font.size": 26,
    "axes.titlesize": 16,
    "axes.labelsize": 26,
    "xtick.labelsize": 20,
    "ytick.labelsize": 20,
    "xtick.major.pad": 8,
    "legend.fontsize": 18,
    "font.family": "serif",
    "font.serif": ["Computer Modern Roman"],
    "figure.subplot.left": 0.15,
    "figure.subplot.bottom": 0.14,
    })

sr = 4096
buff = 256
df = 1.0 / buff
dt = 1.0 / sr
flow = 20
tlen = sr * buff
flen = tlen / 2 + 1

der = 1.70 / 10000

psd = pycbc.psd.iLIGOModel(flen, df, flow)
hp, hc = pycbc.waveform.get_fd_waveform(approximant="TaylorF2",
                         mass1=1.4, mass2=1.4, delta_f=df, f_lower=flow)
hp.resize(flen)

sigmas = []
fls = numpy.arange(flow, 50, 1)
for fl in fls:
    sigma = pycbc.filter.sigma(hp, psd=psd, low_frequency_cutoff=fl)
    sigmas.append(sigma)
    
sigmas = numpy.array(sigmas) / sigmas[0]
pylab.figure(1)
pylab.plot(fls, sigmas**3.0)
pylab.ylabel('Fraction of Optimal Volume')
pylab.grid()
pylab.xlim(xmin=30)
pylab.xlabel("Low Frequency Cutoff (Hz)")
pylab.savefig('flow.png')



l = numpy.array([d(f) for f in fls])
csig = sigmas ** 3.0  * der / l

pylab.figure(2)
pylab.plot(fls, csig)
pylab.ylabel('Fraction of Optimal Volume')
pylab.xlabel("Low Frequency Cutoff (Hz)")
pylab.grid()
pylab.xlim(xmin=30)
pylab.show()
pylab.xlabel("Low Frequency Cutoff (Hz)")
pylab.savefig('flow2.png')
