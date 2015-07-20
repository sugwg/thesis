import pylab, numpy

dat = numpy.loadtxt('cb.dat')

t = dat[:,0]
v = dat[:,1]
e = dat[:,2]
far = dat[:,3]
b= dat[:,4]

i1 = (t == 0.3)
i2 = (t == 0.8)

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


x_values = b[i2]
reach = v[i2]
err = e[i2]
c = 'purple'
pylab.plot(x_values, reach, c=c)
pylab.plot(x_values, reach, alpha=0.8, c='black')
pylab.fill_between(x_values, reach - err, reach + err,
                   facecolor=c, edgecolor=c, alpha=0.8)
pylab.xscale('log')
pylab.xlim(xmin=4)
pylab.grid()
pylab.xlabel('Number of Chisq Bins')
pylab.ylabel("Volume-Time (yr-Mpc$^3$)")
pylab.savefig('cb.png')
