#!/bin/python
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "matplotlib",
#     "numpy",
#     "pandas",
# ]
# ///

import matplotlib.pyplot as plt
import numpy as np

fig, ax = plt.subplots()
x = np.linspace(1, 800, 1000)
y = np.e**x * np.log(1 + np.e**-x)
ax.plot(x, y)
ax.grid(True)
plt.tight_layout()
plt.show()
