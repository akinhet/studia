# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "matplotlib>=3.10.8",
#     "numpy>=2.4.2",
#     "scipy>=1.17.0",
# ]
# ///
import numpy as np
import matplotlib.pyplot as plt


def solve_arcsine_law():
    N_values = [100, 1000, 10000]
    k = 5000
    bins_count = 20
    fig, axes = plt.subplots(1, 3, figsize=(18, 6))

    for i, N in enumerate(N_values):
        print(f"  Przetwarzanie N = {N}...")
        steps = 2 * np.random.binomial(1, 0.5, (k, N)) - 1
        S_paths = np.cumsum(steps, axis=1)
        S_full = np.hstack([np.zeros((k, 1)), S_paths])
        S_current = S_full[:, 1:]
        S_prev = S_full[:, :-1]
        condition_met = (S_current > 0) | (S_prev > 0)
        L_N = np.sum(condition_met, axis=1)
        P_N = L_N / N
        ax = axes[i]
        ax.hist(P_N, bins=bins_count, range=(0, 1), density=True,
                color='skyblue', edgecolor='black', alpha=0.7, label='Symulacja')
        x_theo = np.linspace(0.01, 0.99, 200) 
        y_theo = 1 / (np.pi * np.sqrt(x_theo * (1 - x_theo)))
        ax.plot(x_theo, y_theo, 'r-', linewidth=2.5, label='Teoria (Arcsin Law)')
        ax.set_title(f'N = {N}')
        ax.set_xlabel('Frakcja czasu nad osią ($P_N$)')
        if i == 0:
            ax.set_ylabel('Gęstość prawdopodobieństwa')
        ax.set_xlim(0, 1)
        ax.set_ylim(0, 4) 
        ax.legend(loc='upper center')
        ax.grid(True, alpha=0.3)

    plt.suptitle('Weryfikacja Prawa Arcusa Sinusa dla błądzenia losowego', fontsize=16)
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    solve_arcsine_law()
