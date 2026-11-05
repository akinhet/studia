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
import pandas as pd

K = 50


def draw_scatter(xs, ys, xavg, yavg):
    fig, ax = plt.subplots()
    ax.scatter(xs, ys, c='#7777bb', s=3)
    ax.plot(xavg, yavg, c='#ff0000')
    # ax.set_title(title)
    ax.grid(True)


def draw_graph(x, y):
    fig, ax = plt.subplots()
    ax.plot(x, y)
    # ax.set_title(title)
    ax.grid(True)


def main():
    df = pd.read_csv("wyniki.csv")
    avg = df.groupby('n').mean().reset_index()

    draw_scatter(df['n'], df['cmp'], avg['n'], avg['cmp'])
    draw_scatter(df['n'], df['s'], avg['n'], avg['s'])
    draw_graph(avg['n'], avg['s']/avg['n'])
    draw_graph(avg['n'], avg['s']/(avg['n']*avg['n']))
    draw_graph(avg['n'], avg['cmp']/avg['n'])
    draw_graph(avg['n'], avg['cmp']/(avg['n']*avg['n']))

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
