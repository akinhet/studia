# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "matplotlib>=3.10.9",
#     "pandas>=3.0.2",
# ]
# ///

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('wyniki_z3.csv')

fig, axes = plt.subplots(1, 3, figsize=(18, 5))

styles = {
    3:  {'color': 'red', 'style': ':'},
    5:  {'color': 'green', 'style': '-'},
    7:  {'color': 'blue', 'style': '--'},
    9:  {'color': 'orange', 'style': '-.'},
    19: {'color': 'purple', 'style': '-'},
    21: {'color': 'brown', 'style': '--'}
}

metrics = [
    ('comparisons', 'Średnia liczba porównań', axes[0]),
    ('swaps', 'Średnia liczba przestawień', axes[1]),
    ('time_us', 'Średni czas wykonania [mikrosekundy]', axes[2])
]

for column, ylabel, ax in metrics:
    ax.set_title(ylabel)
    ax.set_xlabel("Rozmiar danych (n)")
    ax.set_ylabel(ylabel)
    ax.grid(True, linestyle='--', alpha=0.7)

    for g in [3, 5, 7, 9, 19, 21]:
        subset = df[df['group_size'] == g]
        ax.plot(subset['n'], subset[column], 
                label=f'k={g}', 
                color=styles[g]['color'], 
                linestyle=styles[g]['style'],
                linewidth=1.5)
    ax.legend()

plt.tight_layout()
plt.savefig('wykresy_grupy.png', dpi=300)
print("Zapisano 'wykresy_grupy.png'.")
plt.show()
