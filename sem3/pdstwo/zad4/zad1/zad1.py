# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "scipy>=1.17.0",
# ]
# ///

from scipy.stats import binom

n = 10
p = 0.5
for i in range(3):
    n = n*10
    ex = n * p
    a1 = 1.2 * ex
    a2 = 1.1 * ex

    p_a = binom.sf(a1 - 1, n, p)
    p_b = 2 * binom.sf(a2 - 1, n, p)
    print(f"a) dla n={n}: {p_a}")
    print(f"b) dla n={n}: {p_b}")
