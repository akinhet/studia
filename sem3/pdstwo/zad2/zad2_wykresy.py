#!/bin/python
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "matplotlib",
#     "numpy",
#     "pandas",
# ]
# ///

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys

K = 50


def draw_scatter(xs, ys, xavg, yavg, title):
    fig, ax = plt.subplots()
    ax.scatter(xs, ys, c='#7777bb', s=3)
    ax.plot(xavg, yavg, c='#ff0000')
    ax.set_title(title)
    ax.grid(True)


def draw_graph(x, y, title):
    fig, ax = plt.subplots()
    ax.plot(x, y)
    ax.set_title(title)
    ax.grid(True)


def main():
    if (len(sys.argv) == 2):
        df = pd.read_csv(sys.argv[1])
    else:
        df = pd.read_csv("wyniki.csv")

    avg = df.groupby('n').mean().reset_index()

    draw_scatter(df['n'], df['Bn'], avg['n'], avg['Bn'], "Bn - pierwsza kolizja")
    draw_scatter(df['n'], df['Un'], avg['n'], avg['Un'], "Un - puste urny po wrzuceniu n kul")
    draw_scatter(df['n'], df['Cn'], avg['n'], avg['Cn'], "Cn - conajmniej jedna kula w każdej urnie")
    draw_scatter(df['n'], df['Dn'], avg['n'], avg['Dn'], "Dn - conajmniej dwie kule w każdej urnie")
    draw_scatter(df['n'], df['Dn-Cn'], avg['n'], avg['Dn-Cn'], "Dn - Cn")

    draw_graph(avg['n'], avg['Bn']/avg['n'], "Bn/n")
    draw_graph(avg['n'], avg['Bn']/np.sqrt(avg['n']), "Bn/sqrt(n)")

    draw_graph(avg['n'], avg['Un']/avg['n'], "Un/n")

    draw_graph(avg['n'], avg['Cn']/avg['n'], "Cn/n")
    draw_graph(avg['n'], avg['Cn']/(avg['n'] * np.log(avg['n'])), "Cn/n ln(n)")
    draw_graph(avg['n'], avg['Cn']/(avg['n'] * avg['n']), "Cn/n^2")

    draw_graph(avg['n'], avg['Dn']/avg['n'], "Dn/n")
    draw_graph(avg['n'], avg['Dn']/(avg['n'] * np.log(avg['n'])), "Dn/n ln(n)")
    draw_graph(avg['n'], avg['Dn']/(avg['n'] * avg['n']), "Dn/n^2")

    draw_graph(avg['n'], avg['Dn-Cn']/avg['n'], "(Dn - Cn)/n")
    draw_graph(avg['n'], avg['Dn-Cn']/(avg['n'] * np.log(avg['n'])), "(Dn - Cn)/n ln(n)")
    draw_graph(avg['n'], avg['Dn-Cn']/(avg['n'] * np.log(np.log(avg['n']))), "(Dn - Cn)/n ln(ln(n))")

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
