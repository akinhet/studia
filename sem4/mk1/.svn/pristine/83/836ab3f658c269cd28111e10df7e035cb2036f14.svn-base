# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "matplotlib>=3.10.9",
#     "pandas>=3.0.2",
# ]
# ///
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('wyniki1.csv')

df_asc = df[df['scenariusz'] == 1].sort_values('n')
df_rand = df[df['scenariusz'] == 0].sort_values('n')

metrics = {
    'Porównania kluczy': {
        'sum_col': 'avg_ins_comp', 'max_col': 'max_ins_comp',
        'sum_col_del': 'avg_del_comp', 'max_col_del': 'max_del_comp',
        'filename': 'wykres_porownania.png'
    },
    'Operacje na wskaźnikach': {
        'sum_col': 'avg_ins_ptr', 'max_col': 'max_ins_ptr',
        'sum_col_del': 'avg_del_ptr', 'max_col_del': 'max_del_ptr',
        'filename': 'wykres_wskazniki.png'
    },
    'Wysokość drzewa': {
        'sum_col': 'avg_ins_h', 'max_col': 'max_ins_h',
        'sum_col_del': 'avg_del_h', 'max_col_del': 'max_del_h',
        'filename': 'wykres_wysokosc.png'
    }
}

for title, cols in metrics.items():
    plt.figure(figsize=(12, 8))

    plt.plot(df_asc['n'], df_asc[cols['sum_col']], 'b-o', label='Wstawianie: Suma (Ciąg rosnący)')
    plt.plot(df_asc['n'], df_asc[cols['max_col']], 'c--s', label='Wstawianie: Maks (Ciąg rosnący)')
    plt.plot(df_asc['n'], df_asc[cols['sum_col_del']], 'r-o', label='Usuwanie: Suma (Ciąg rosnący)')
    plt.plot(df_asc['n'], df_asc[cols['max_col_del']], 'm--s', label='Usuwanie: Maks (Ciąg rosnący)')

    plt.plot(df_rand['n'], df_rand[cols['sum_col']], 'g-.^', label='Wstawianie: Suma (Losowy)')
    plt.plot(df_rand['n'], df_rand[cols['max_col']], 'y:v', label='Wstawianie: Maks (Losowy)')
    plt.plot(df_rand['n'], df_rand[cols['sum_col_del']], 'k-.^', label='Usuwanie: Suma (Losowy)')
    plt.plot(df_rand['n'], df_rand[cols['max_col_del']], 'gray', label='Usuwanie: Maks (Losowy)')

    plt.title(f'Złożoność eksperymentalna: {title}', fontsize=14, fontweight='bold')
    plt.xlabel('Rozmiar danych (n)', fontsize=12)
    plt.ylabel('Wartość miary (liczba operacji / jednostki)', fontsize=12)
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')

    plt.tight_layout()

    plt.savefig(cols['filename'], dpi=300)
    print(f"Wygenerowano wykres: {cols['filename']}")
    plt.show()
    plt.close()
