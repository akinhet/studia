# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "matplotlib>=3.10.9",
#     "pandas>=3.0.2",
# ]
# ///

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('wyniki.csv')

fig, axes = plt.subplots(1, 2, figsize=(16, 6))

colors = {'RS': 'blue', 'SELECT': 'red'}
linestyles = {'min': 'dotted', 'fourth': (0, (5, 10)), 'third': 'dashdot', 'mediana': 'solid', 'max': 'dashed'}

ax1 = axes[0]
ax1.set_title("Liczba Porównań")
ax1.set_xlabel("Rozmiar danych wejściowych (n)")
ax1.set_ylabel("Średnia liczba porównań (m=50)")

ax2 = axes[1]
ax2.set_title("Liczba Przestawień")
ax2.set_xlabel("Rozmiar danych wejściowych (n)")
ax2.set_ylabel("Średnia liczba przestawień (m=50)")

for algo in ['RS', 'SELECT']:
    for k_type in ['min', 'fourth', 'third', 'mediana', 'max']:
        subset = df[(df['algo'] == algo) & (df['k_type'] == k_type)]

        label_name = f"{algo} (k={k_type})"

        ax1.plot(subset['n'], subset['comparisons'], 
                 label=label_name, color=colors[algo], linestyle=linestyles[k_type])

        ax2.plot(subset['n'], subset['swaps'], 
                 label=label_name, color=colors[algo], linestyle=linestyles[k_type])

for ax in axes:
    ax.grid(True, linestyle='--', alpha=0.7)
    ax.legend()

plt.tight_layout()
plt.savefig('wykresy_zlozonosci.png', dpi=300)
print("Wykresy wygenerowane i zapisane do pliku 'wykresy_zlozonosci.png'.")
plt.show()
