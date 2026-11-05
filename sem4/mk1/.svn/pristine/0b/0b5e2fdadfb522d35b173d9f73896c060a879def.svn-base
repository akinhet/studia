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


def main():
    ins = pd.read_csv("insertion.csv")
    qui = pd.read_csv("quick.csv")
    hyb = pd.read_csv("hybrid.csv")

    # k = 100
    fig = plt.figure()
    ax = fig.subplots(2,2)

    insavg = ins.groupby('n').mean().reset_index()
    quiavg = qui.groupby('n').mean().reset_index()
    hybavg = hyb.groupby('n').mean().reset_index()

    ax[0,0].plot(insavg['n'], insavg['compares'], label="insertion")
    ax[0,0].plot(quiavg['n'], quiavg['compares'], label="quick"    )
    ax[0,0].plot(hybavg['n'], hybavg['compares'], label="hybrid"   )
    ax[0,0].set_title("Średnia porównań")

    ax[1,0].plot(insavg['n'], insavg['moves'], label="insertion")
    ax[1,0].plot(quiavg['n'], quiavg['moves'], label="quick"    )
    ax[1,0].plot(hybavg['n'], hybavg['moves'], label="hybrid"   )
    ax[1,0].set_title("Średnia przestawień")

    ax[0,1].plot(insavg['n'], insavg['compares']/insavg['n'], label="insertion")
    ax[0,1].plot(quiavg['n'], quiavg['compares']/quiavg['n'], label="quick"    )
    ax[0,1].plot(hybavg['n'], hybavg['compares']/hybavg['n'], label="hybrid"   )
    ax[0,1].set_title("Średnia porównań/n")

    ax[1,1].plot(insavg['n'], insavg['moves']/insavg['n'], label="insertion")
    ax[1,1].plot(quiavg['n'], quiavg['moves']/quiavg['n'], label="quick"    )
    ax[1,1].plot(hybavg['n'], hybavg['moves']/hybavg['n'], label="hybrid"   )
    ax[1,1].set_title("Średnia przestawień/n")

    # k = 10
    fig = plt.figure()
    ax = fig.subplots(2,2)

    insavg = ins.groupby('n').head(10).groupby('n').mean().reset_index()
    quiavg = qui.groupby('n').head(10).groupby('n').mean().reset_index()
    hybavg = hyb.groupby('n').head(10).groupby('n').mean().reset_index()

    ax[0,0].plot(insavg['n'], insavg['compares'], label="insertion")
    ax[0,0].plot(quiavg['n'], quiavg['compares'], label="quick"    )
    ax[0,0].plot(hybavg['n'], hybavg['compares'], label="hybrid"   )
    ax[0,0].set_title("Średnia porównań")

    ax[1,0].plot(insavg['n'], insavg['moves'], label="insertion")
    ax[1,0].plot(quiavg['n'], quiavg['moves'], label="quick"    )
    ax[1,0].plot(hybavg['n'], hybavg['moves'], label="hybrid"   )
    ax[1,0].set_title("Średnia przestawień")

    ax[0,1].plot(insavg['n'], insavg['compares']/insavg['n'], label="insertion")
    ax[0,1].plot(quiavg['n'], quiavg['compares']/quiavg['n'], label="quick"    )
    ax[0,1].plot(hybavg['n'], hybavg['compares']/hybavg['n'], label="hybrid"   )
    ax[0,1].set_title("Średnia porównań/n")

    ax[1,1].plot(insavg['n'], insavg['moves']/insavg['n'], label="insertion")
    ax[1,1].plot(quiavg['n'], quiavg['moves']/quiavg['n'], label="quick"    )
    ax[1,1].plot(hybavg['n'], hybavg['moves']/hybavg['n'], label="hybrid"   )
    ax[1,1].set_title("Średnia przestawień/n")

    # k = 1
    fig = plt.figure()
    ax = fig.subplots(2,2)

    insavg = ins.groupby('n').head(1).groupby('n').mean().reset_index()
    quiavg = qui.groupby('n').head(1).groupby('n').mean().reset_index()
    hybavg = hyb.groupby('n').head(1).groupby('n').mean().reset_index()

    ax[0,0].plot(insavg['n'], insavg['compares'], label="insertion")
    ax[0,0].plot(quiavg['n'], quiavg['compares'], label="quick"    )
    ax[0,0].plot(hybavg['n'], hybavg['compares'], label="hybrid"   )
    ax[0,0].set_title("Średnia porównań")

    ax[1,0].plot(insavg['n'], insavg['moves'], label="insertion")
    ax[1,0].plot(quiavg['n'], quiavg['moves'], label="quick"    )
    ax[1,0].plot(hybavg['n'], hybavg['moves'], label="hybrid"   )
    ax[1,0].set_title("Średnia przestawień")

    ax[0,1].plot(insavg['n'], insavg['compares']/insavg['n'], label="insertion")
    ax[0,1].plot(quiavg['n'], quiavg['compares']/quiavg['n'], label="quick"    )
    ax[0,1].plot(hybavg['n'], hybavg['compares']/hybavg['n'], label="hybrid"   )
    ax[0,1].set_title("Średnia porównań/n")

    ax[1,1].plot(insavg['n'], insavg['moves']/insavg['n'], label="insertion")
    ax[1,1].plot(quiavg['n'], quiavg['moves']/quiavg['n'], label="quick"    )
    ax[1,1].plot(hybavg['n'], hybavg['moves']/hybavg['n'], label="hybrid"   )
    ax[1,1].set_title("Średnia przestawień/n")

    plt.tight_layout()
    plt.legend()
    plt.show()


if __name__ == "__main__":
    main()
