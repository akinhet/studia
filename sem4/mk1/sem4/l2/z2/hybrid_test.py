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
    fig = plt.figure()
    ax1, ax2 = fig.subplots(1,2)
    df = pd.read_csv("hybridtest.csv")
    avg = df.groupby('s').mean().reset_index()

    ax1.plot(avg['s'], avg['moves'])
    ax1.set_title("Średnia przestawień")

    ax2.plot(avg['s'], avg['compares'])
    ax2.set_title("Średnia porównań")

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
