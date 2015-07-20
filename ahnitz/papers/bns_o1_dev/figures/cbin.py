import pycbc.psd, numpy, pylab, pycbc.filter, pycbc.waveform, pycbc.vetoes
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

sr = 2048
buff = 256
df = 1.0 / buff
dt = 1.0 / sr
flow = 40
tlen = sr * buff
flen = tlen / 2 + 1

psd = pycbc.psd.iLIGOModel(flen, df, flow)
hp, hc = pycbc.waveform.get_fd_waveform(approximant="TaylorF2",
                         mass1=1.4, mass2=1.4, delta_f=df, f_lower=flow)
hp.resize(flen)

bins = pycbc.vetoes.power_chisq_bins(hp, 16, psd, low_frequency_cutoff=flow)
freq = numpy.array(bins) / buff

t = numpy.array([d(f) for f in freq])
time = t[1:] - t[0:1]
time = - numpy.append([0], time)
print time


freq = freq[::-1]
time = time[::-1]

c = None
for i in range(len(time)-1):
    c = 'black' if c is not 'black' else 'grey'
    pylab.plot([time[i], time[i+1]], [freq[i], freq[i+1]], color=c, linewidth=10)
    
pylab.grid(which='both')
pylab.ylim(10, 1000)
pylab.yscale('log')
pylab.xlabel('Time (s)')
pylab.ylabel('Frequency (Hz)')
pylab.savefig('bin.png')
