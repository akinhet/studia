#!/usr/bin/env python3

class Polynomial:
    def __init__(self, terms=None):
        self.terms = terms if terms is not None else {}
        self.clean()

    def __str__(self):
        if self.is_zero(): return "0"
        parts = []
        for exp in sorted(self.terms.keys(), reverse=True):
            c = self.terms[exp]
            var_str = "".join([f"{['x','y','z'][i]}^{e}" for i, e in enumerate(exp) if e > 0])
            parts.append(f"{c}{var_str}")
        return " + ".join(parts).replace("+ -", "- ")

    def clean(self):
        self.terms = {exp: c for exp, c in self.terms.items() if abs(c) > 1e-10}

    def is_zero(self):
        return len(self.terms) == 0

    def __add__(self, other):
        result = dict(self.terms)
        for exp, c in other.terms.items():
            result[exp] = result.get(exp, 0) + c
        return Polynomial(result)

    def __sub__(self, other):
        result = dict(self.terms)
        for exp, c in other.terms.items():
            result[exp] = result.get(exp, 0) - c
        return Polynomial(result)

    def __mul__(self, other):
            result = {}
            for exp1, c1 in self.terms.items():
                for exp2, c2 in other.terms.items():
                    new_exp = tuple(a + b for a, b in zip(exp1, exp2))
                    result[new_exp] = result.get(new_exp, 0) + c1 * c2
            return Polynomial(result)

    def get_leading_term(self, order_key):
        if self.is_zero():
            return None, 0.0
        max_exp = max(self.terms.keys(), key=order_key)
        return max_exp, self.terms[max_exp]


def lex_order(exp):
    return exp

def get_permuted_lex_order(permutation):
    def permuted_lex_order(exp):
        return tuple(exp[i] for i in permutation)
    return permuted_lex_order

def grlex_order(exp):
    return (sum(exp), exp)

def divides(exp_divisor, exp_dividend):
    return all(d <= div for d, div in zip(exp_divisor, exp_dividend))

def subtract_exp(exp_dividend, exp_divisor):
    return tuple(div - d for d, div in zip(exp_divisor, exp_dividend))

def PolynomialReduce(f: Polynomial, G: list[Polynomial], order_key) -> tuple[list[Polynomial], Polynomial]:
    n = len(G)
    alphas = [Polynomial() for _ in range(n)] # ciąg α1, ..., αn (początkowo zera)
    r = Polynomial()                          # reszta (początkowo 0)
    p = f                                     # wielomian, który będziemy redukować

    G_LTs = [g.get_leading_term(order_key) for g in G]

    while not p.is_zero():
        p_exp, p_coeff = p.get_leading_term(order_key)
        division_occurred = False

        for i, (g_exp, g_coeff) in enumerate(G_LTs):
            if g_exp is None:
                continue

            if divides(g_exp, p_exp):
                t_exp = subtract_exp(p_exp, g_exp)
                t_coeff = p_coeff / g_coeff

                alphas[i] = alphas[i] + Polynomial({t_exp: t_coeff})

                term_to_subtract = G[i].multiply_by_term(t_coeff, t_exp)
                p = p - term_to_subtract

                division_occurred = True
                break # Po udanym podzieleniu przez pierwsze g_i przerywamy pętlę i szukamy od nowa

        if not division_occurred:
            r = r + Polynomial({p_exp: p_coeff})
            p = p - Polynomial({p_exp: p_coeff})

    return alphas, r

def run_part_d():
    print("--- ROZWIĄZANIE PODPUNKTU d) ---")

    f = Polynomial({(3, 0, 0): 1.0, (2, 1, 0): -1.0, (2, 0, 1): -1.0}) # x^3 - x^2y - x^2z
    g1 = Polynomial({(2, 1, 0): 1.0, (0, 0, 1): -1.0})                 # x^2y - z
    g2 = Polynomial({(1, 1, 0): 1.0, (0, 0, 0): -1.0})                 # xy - 1

    print(f"Wielomian f:  {f}")
    print(f"Wielomian g1: {g1}")
    print(f"Wielomian g2: {g2}")

    alphas1, r1 = PolynomialReduce(f, [g1, g2], grlex_order)
    print(f"\n1. Redukcja przez (g1, g2):")
    print(f"   Reszta r1 = {r1}")

    alphas2, r2 = PolynomialReduce(f, [g2, g1], grlex_order)
    print(f"\n2. Redukcja przez (g2, g1):")
    print(f"   Reszta r2 = {r2}")

    diff = r1 - r2
    print(f"\n3. Różnica reszt (r1 - r2) = {diff}")

    x_poly = Polynomial({(1, 0, 0): 1.0}) # Wielomian 'x'

    combination = g1 - (x_poly * g2)

    print(f"   Sprawdzenie równości g1 - x*g2: {combination}")
    if diff.terms == combination.terms:
        print("   Wniosek: r1 - r2 należy do ideału <g1, g2>!")
    print("-" * 40)


def run_part_e():
    print("\n--- ROZWIĄZANIE PODPUNKTU e) ---")

    h = Polynomial({
        (2, 8, 0): 1.0,
        (0, 3, 9): -1.0,
        (6, 0, 1): 1.0
    })

    g = Polynomial({(1, 0, 0): 1.0, (0, 1, 0): 1.0, (0, 0, 1): 1.0})
    G = [g]

    print(f"Wielomian h: {h}")
    print(f"Generator G: [{g}]")

    lex_x_y_z = get_permuted_lex_order((0, 1, 2))

    lex_y_x_z = get_permuted_lex_order((1, 0, 2))

    lex_z_x_y = get_permuted_lex_order((2, 0, 1))

    _, res_x = PolynomialReduce(h, G, lex_x_y_z)
    _, res_y = PolynomialReduce(h, G, lex_y_x_z)
    _, res_z = PolynomialReduce(h, G, lex_z_x_y)

    print("\nWyniki redukcji wielomianu h przez G dla 3 różnych porządków:")
    print(f"1. Porządek (x > y > z):")
    print(f"   Reszta składa się ze zmiennych y, z:\n   {res_x}\n")

    print(f"2. Porządek (y > x > z):")
    print(f"   Reszta składa się ze zmiennych x, z:\n   {res_y}\n")

    print(f"3. Porządek (z > x > y):")
    print(f"   Reszta składa się ze zmiennych x, y:\n   {res_z}\n")


if __name__ == "__main__":
    run_part_d()
    run_part_e()
