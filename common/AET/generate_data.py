#!/usr/bin/env ipython

"""
use this script to generate new AET
currently it is not used
"""

import numpy as np

alphabet = np.array([chr(x + 65) for x in range(26)])

rng = np.random.default_rng(seed=42)  # <--- adjust this value if you want to generate an entirely new AET
grid = np.zeros((26, 26), dtype='<U1')
for y in range(26):
    grid[y, :] = rng.permutation(alphabet)

with open('AET-100.dat', 'w') as fd:
    for y in range(26):
        fd.write(','.join(grid[y, :]) + '\n')
