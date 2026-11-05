#!/bin/python
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "matplotlib",
#     "numpy",
# ]
# ///

import matplotlib.pyplot as plt
import numpy as np
import random
import math

def main():
    k = 50

    fig, ax = plt.subplots(ncols=2, nrows=2)
    avg = []
    for n in range(50, 5050, 50):
        results = approx_area(lambda x, y: x**(1/3) >= y, 0, 8, 2, k, n)
        ax[0,0].scatter([n]*k, results, c='#7777bb', s=3)
        avg.append(sum(results) / len(results))
    ax[0,0].scatter([x for x in range(50, 5050, 50)], avg, c='#ff0000', s=20)
    ax[0,0].set_title("Integral 1")
    ax[0,0].plot([0, 5000], [12,12], color = 'g')

    avg = []
    for n in range(50, 5050, 50):
        results = approx_area(lambda x, y: math.sin(x) >= y, 0, math.pi, 1, k, n)
        ax[1,0].scatter([n]*k, results, c='#7777bb', s=3)
        avg.append(sum(results) / len(results))
    ax[1,0].scatter([x for x in range(50, 5050, 50)], avg, c='#ff0000', s=20)
    ax[1,0].set_title("Integral 2")
    ax[1,0].plot([0, 5000], [2,2], color = 'g')

    avg = []
    for n in range(50, 5050, 50):
        results = approx_area(lambda x, y: 4*x*((1-x)**3) >= y, 0, 1, 0.5, k, n)
        ax[0,1].scatter([n]*k, results, c='#7777dd', s=3)
        avg.append(sum(results) / len(results))
    ax[0,1].scatter([x for x in range(50, 5050, 50)], avg, c='#ff0000', s=20)
    ax[0,1].set_title("Integral 3")
    ax[0,1].plot([0, 5000], [0.2,0.2], color = 'g')

    avg = []
    for n in range(50, 5050, 50):
        results = approx_area(lambda x, y: (x-1)**2 + (y-1)**2 <= 1, 0, 2, 2, k, n)
        ax[1,1].scatter([n]*k, results, c='#7777dd', s=3)
        avg.append(sum(results) / len(results))
    ax[1,1].scatter([x for x in range(50, 5050, 50)], avg, c='#ff0000', s=20)
    ax[1,1].set_title("Pi")
    ax[1,1].plot([0, 5000], [math.pi,math.pi], color = 'g')

    plt.show()

def rand():
    return random.random()

def approx_area(function, a, b, M, k, n):
    areas = []
    for _ in range(k):
        hit = 0

        for _ in range(n):
            x = a + (b - a) * rand()
            y = M * rand()

            if function(x, y):
                hit += 1

        areas.append(hit / n * (b - a) * M)

    return areas

if __name__ == "__main__":
    main()
