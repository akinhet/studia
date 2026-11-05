# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "matplotlib>=3.10.9",
#     "pandas>=3.0.2",
# ]
# ///

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('wyniki_z4.csv')

fig, axes = plt.subplots(1, 2, figsize=(16, 6))

titles = {
    'f1': r"Koszt wyszukiwania dla $f(x) = (\log_2(x+1))^3, \delta = 10$",
    'f2': r"Koszt wyszukiwania dla $f(x) = \sqrt{x} + \log_2(x+1), \delta = 50$"
}

colors = {'Standard': 'red', 'Custom': 'green'}

for i, func in enumerate(['f1', 'f2']):
    ax = axes[i]
    ax.set_title(titles[func], fontsize=14)
    ax.set_xlabel("Rozmiar tablicy (n)", fontsize=12)
    ax.set_ylabel("Liczba porównań elementów w tablicy", fontsize=12)
    ax.grid(True, linestyle='--', alpha=0.7)

    for algo in ['Standard', 'Custom']:
        subset = df[(df['func_type'] == func) & (df['algo'] == algo)]
        ax.plot(subset['n'], subset['comparisons'], 
                label=f'Binary Search ({algo})', 
                color=colors[algo], 
                linewidth=2)

    ax.legend(fontsize=12)

plt.tight_layout()
plt.savefig('wykresy_z4.png', dpi=300)
print("Wykresy zostały zapisane jako 'wykresy_z4.png'.")
plt.show()
