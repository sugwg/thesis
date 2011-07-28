#!/usr/bin/env python

import glob

figures = glob.glob('figure_*')
keys    = {}

for f in figures:
    if f == 'figure_1_-0_25_02.png':
        continue

    key = f[:-7]

    if key in keys:
        keys[key].append(f)
    else:
        keys[key] = [f]



ends = ['','\\\\']

for key in keys:
    print '\\begin{figure}'
    
    if len(keys[key]) == 2:
        print '  \\includegraphics[width=\\linewidth]{figures/ninja2/%s}' % keys[key][0]
    else:
        for count, f in enumerate(keys[key]):
            print '  \\includegraphics[width=0.5\\linewidth]{figures/ninja2/%s}' % f,

            print ends[count % 2]

    key2 = key.replace('d','.')

    description = 'Overlap plots for $q=%s$ $S_{z1} = S_{z2} = %s$' % (key2.split('_')[1], key2.split('_')[2])

    print '  \\caption[%s]{' % description
    print '  \\label{f:%s}' % key
    print '%s}' % description
    print '\\end{figure}%'
    print
    print






