#!/bin/python
# /// script
# remysortres-python = ">=3.13"
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
    merge = pd.read_csv("merge.csv")
    mysort = pd.read_csv("mysort.csv")

    # k = 100
    fig = plt.figure()
    ax = fig.subplots(2,2)

    mergeavg = merge.groupby('n').mean().reset_index()
    mysortavg = mysort.groupby('n').mean().reset_index()

    ax[0,0].plot(mergeavg['n'], mergeavg['compares'], label="merge")
    ax[0,0].plot(mysortavg['n'], mysortavg['compares'], label="mysort"    )
    ax[0,0].set_title("Średnia porównań")

    ax[1,0].plot(mergeavg['n'], mergeavg['moves'], label="merge")
    ax[1,0].plot(mysortavg['n'], mysortavg['moves'], label="mysort"    )
    ax[1,0].set_title("Średnia przestawień")

    ax[0,1].plot(mergeavg['n'], mergeavg['compares']/mergeavg['n'], label="merge")
    ax[0,1].plot(mysortavg['n'], mysortavg['compares']/mysortavg['n'], label="mysort"    )
    ax[0,1].set_title("Średnia porównań/n")

    ax[1,1].plot(mergeavg['n'], mergeavg['moves']/mergeavg['n'], label="merge")
    ax[1,1].plot(mysortavg['n'], mysortavg['moves']/mysortavg['n'], label="mysort"    )
    ax[1,1].set_title("Średnia przestawień/n")

    # # k = 10
    # fig = plt.figure()
    # ax = fig.subplots(2,2)
    #
    # mergeavg = merge.groupby('n').head(10).groupby('n').mean().reset_index()
    # mysortavg = mysort.groupby('n').head(10).groupby('n').mean().reset_index()
    #
    # ax[0,0].plot(mergeavg['n'], mergeavg['compares'], label="merge")
    # ax[0,0].plot(mysortavg['n'], mysortavg['compares'], label="mysort"    )
    # ax[0,0].set_title("Średnia porównań")
    #
    # ax[1,0].plot(mergeavg['n'], mergeavg['moves'], label="merge")
    # ax[1,0].plot(mysortavg['n'], mysortavg['moves'], label="mysort"    )
    # ax[1,0].set_title("Średnia przestawień")
    #
    # ax[0,1].plot(mergeavg['n'], mergeavg['compares']/mergeavg['n'], label="merge")
    # ax[0,1].plot(mysortavg['n'], mysortavg['compares']/mysortavg['n'], label="mysort"    )
    # ax[0,1].set_title("Średnia porównań/n")
    #
    # ax[1,1].plot(mergeavg['n'], mergeavg['moves']/mergeavg['n'], label="merge")
    # ax[1,1].plot(mysortavg['n'], mysortavg['moves']/mysortavg['n'], label="mysort"    )
    # ax[1,1].set_title("Średnia przestawień/n")
    #
    # # k = 1
    # fig = plt.figure()
    # ax = fig.subplots(2,2)
    #
    # mergeavg = merge.groupby('n').head(1).groupby('n').mean().reset_index()
    # mysortavg = mysort.groupby('n').head(1).groupby('n').mean().reset_index()
    #
    # ax[0,0].plot(mergeavg['n'], mergeavg['compares'], label="merge")
    # ax[0,0].plot(mysortavg['n'], mysortavg['compares'], label="mysort"    )
    # ax[0,0].set_title("Średnia porównań")
    #
    # ax[1,0].plot(mergeavg['n'], mergeavg['moves'], label="merge")
    # ax[1,0].plot(mysortavg['n'], mysortavg['moves'], label="mysort"    )
    # ax[1,0].set_title("Średnia przestawień")
    #
    # ax[0,1].plot(mergeavg['n'], mergeavg['compares']/mergeavg['n'], label="merge")
    # ax[0,1].plot(mysortavg['n'], mysortavg['compares']/mysortavg['n'], label="mysort"    )
    # ax[0,1].set_title("Średnia porównań/n")
    #
    # ax[1,1].plot(mergeavg['n'], mergeavg['moves']/mergeavg['n'], label="merge")
    # ax[1,1].plot(mysortavg['n'], mysortavg['moves']/mysortavg['n'], label="mysort"    )
    # ax[1,1].set_title("Średnia przestawień/n")

    plt.tight_layout()
    plt.legend()
    plt.show()


if __name__ == "__main__":
    main()
