#!/bin/python
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "matplotlib",
#     "numpy",
#     "pandas",
# ]
# ///

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('bin.csv')

plt.figure(figsize=(10, 6))
avg = df.groupby('n').mean().reset_index()
plt.plot(avg['n'], avg['compares'], 'o-', label='Binary search O(min(m,n) log max(m,n))')

df = pd.read_csv('search.csv')

avg = df.groupby('n').mean().reset_index()
plt.plot(avg['n'], avg['compares'], 'o-', label='Stair search O(m + n)')

plt.title('Złożoność algorytmu wyszukiwania w macierzy posortowanej')
plt.xlabel('Rozmiar macierzy (n x (10000/n))')
plt.ylabel('Liczba porównań')
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()

plt.savefig('wykres_zlozonosci.png')
plt.show()
