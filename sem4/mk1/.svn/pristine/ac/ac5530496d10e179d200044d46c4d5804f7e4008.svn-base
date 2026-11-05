# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "matplotlib>=3.10.9",
#     "pandas>=3.0.2",
# ]
# ///
import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv("wyniki.csv")

plt.figure(figsize=(10, 6))

plt.plot(df['n'], df['Max_Rounds'], marker='^', linestyle='--', color='crimson', label='Maksymalna liczba rund')
plt.plot(df['n'], df['Avg_Rounds'], marker='o', linestyle='-', color='darkblue', linewidth=2, label='Średnia liczba rund')
plt.plot(df['n'], df['Min_Rounds'], marker='v', linestyle='--', color='forestgreen', label='Minimalna liczba rund')

plt.fill_between(df['n'], df['Min_Rounds'], df['Max_Rounds'], color='gray', alpha=0.15, label='Obszar zmienności (Min-Max)')

plt.title('Analiza liczby rund rozsyłania wiadomości w drzewie MST', fontsize=14, pad=15)
plt.xlabel('Liczba wierzchołków drzewa ($n$)', fontsize=12)
plt.ylabel('Liczba rund', fontsize=12)
plt.grid(True, linestyle=':', alpha=0.6)
plt.xticks(df['n'])
plt.legend(fontsize=11, loc='upper left')

plt.tight_layout()
plt.savefig("wykres.png", dpi=300)
plt.show()
