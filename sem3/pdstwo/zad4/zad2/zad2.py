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
from scipy import stats


def solve_random_walk_problem():
    N_values = [5, 10, 15, 20, 25, 30]
    k = 10000
    fig, axes = plt.subplots(2, 3, figsize=(18, 10))
    axes = axes.flatten()

    for i, N in enumerate(N_values):
        steps = 2 * np.random.binomial(1, 0.5, (k, N)) - 1
        S_N = np.sum(steps, axis=1)
        res = stats.ecdf(S_N)
        x_emp = res.cdf.quantiles
        y_emp = res.cdf.probabilities

        ex = 0
        sigma = np.sqrt(N)
        x_theo = np.linspace(min(S_N), max(S_N), 200)
        y_theo = stats.norm.cdf(x_theo, loc=ex, scale=sigma)
        ax = axes[i]
        ax.step(x_emp, y_emp, label='Empiryczna (Symulacja)', where='post', color='blue', linewidth=1.5)
        ax.plot(x_theo, y_theo, label=f'Teoretyczna N(0, {N})', color='red', linestyle='--', linewidth=2)
        ax.set_title(f'N = {N}')
        ax.set_xlabel('Wartość $S_N$')
        ax.set_ylabel('Prawdopodobieństwo')
        ax.grid(True, alpha=0.3)
        ax.legend()

    N = 100
    steps = 2 * np.random.binomial(1, 0.5, (k, N)) - 1
    S_N = np.sum(steps, axis=1)
    res = stats.ecdf(S_N)
    x_emp = res.cdf.quantiles
    y_emp = res.cdf.probabilities

    ex = 0
    sigma = np.sqrt(N)
    x_theo = np.linspace(min(S_N), max(S_N), 200)
    y_theo = stats.norm.cdf(x_theo, loc=ex, scale=sigma)
    fig, ax = plt.subplots()
    ax.step(x_emp, y_emp, label='Empiryczna (Symulacja)', where='post', color='blue', linewidth=1.5)
    ax.plot(x_theo, y_theo, label=f'Teoretyczna N(0, {N})', color='red', linestyle='--', linewidth=2)
    ax.set_title(f'N = {N}')
    ax.set_xlabel('Wartość $S_N$')
    ax.set_ylabel('Prawdopodobieństwo')
    ax.grid(True, alpha=0.3)
    ax.legend()

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    solve_random_walk_problem()
