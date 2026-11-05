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


def draw_scatter(xs, ys, xavg, yavg):
    fig, ax = plt.subplots()
    ax.scatter(xs, ys, c='#7777bb', s=3)
    ax.plot(xavg, yavg, c='#ff0000')
    ax.plot(xavg, np.log(xavg)/np.log(1/0.5))
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
    draw_graph(avg['n'], avg['T']/np.log(avg['n']))
    draw_scatter(df['n'], df['T'], avg['n'], avg['T'])

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
