#! /usr/bin/env python
# -*- coding:utf-8 -*-
#
# written by Shotaro Fujimoto, May 2014.
""" This program is the simuration of random walk in two-dimentional space.
"""

import numpy as np
cimport numpy as np
import matplotlib.pyplot as plt

DTYPE = np.int
ctypedef np.int_t DTYPE_t


def random_walk_d2(N, nwalkers, l=1, x0=0, y0=0):
    """ Random walk in two-dimentional space.
    """
    global x, y
    x = np.zeros([nwalkers, max(N)], 'i')
    y = np.zeros([nwalkers, max(N)], 'i')
    p = np.random.random([nwalkers, max(N) - 1])

    cdef int n, i
    for n in range(nwalkers):
        x[n][0] = x0
        y[n][0] = y0
        for i in range(1, max(N)):
            if p[n][i - 1] < 0.25:
                x[n][i] = x[n][i - 1] + l
                y[n][i] = y[n][i - 1]
            elif p[n][i - 1] < 0.5:
                x[n][i] = x[n][i - 1] - l
                y[n][i] = y[n][i - 1]
            elif p[n][i - 1] < 0.75:
                x[n][i] = x[n][i - 1]
                y[n][i] = y[n][i - 1] + l
            else:
                x[n][i] = x[n][i - 1]
                y[n][i] = y[n][i - 1] - l


def calc(int nwalkers):
    """ Caluculate the average and the variance of x(N) and y(N)
    """
    x_ave = np.sum(x, axis=0, dtype=np.float32) / nwalkers * 1.
    y_ave = np.sum(y, axis=0, dtype=np.float32) / nwalkers * 1.
    x_2_ave = np.sum(x ** 2, axis=0, dtype=np.float32) / nwalkers * 1.
    y_2_ave = np.sum(y ** 2, axis=0, dtype=np.float32) / nwalkers * 1.
    variance_x = x_2_ave - x_ave ** 2
    variance_y = y_2_ave - y_ave ** 2
    R_2 = x_2_ave + y_2_ave - x_ave ** 2 - y_ave ** 2

    return [x_ave, y_ave, variance_x, variance_y, R_2]


def draw_figure(int nwalkers):
    """ Draw the figure of two-dimentional random walk.
    """
    fig = plt.figure('random walk figure')
    ax = fig.add_subplot(111, aspect='equal')
    ax.grid()
    xmin, xmax = np.amin(x), np.amax(x)
    ymin, ymax = np.amin(y), np.amax(y)
    xmargin, ymargin = (xmax - xmin) * 0.05, (ymax - ymin) * 0.05
    ax.set_xlim(xmin - xmargin, xmax + xmargin)
    ax.set_ylim(ymin - ymargin, ymax + ymargin)
    ax.set_xlabel(r'$x$')
    ax.set_ylabel(r'$y$')

    cdef int n
    for n in range(nwalkers):
        l, = ax.plot([], [], 'r-')
        l.set_data(x[n], y[n])
    plt.show()


def plot_graph(x_data, y_data, x_labels, y_labels):
    """ Plot the graph about y_data for each x_data.
    """
    d = len(y_data)
    if not len(x_data) == len(y_data) == len(x_labels) == len(y_labels):
        raise ValueError("Arguments must have the same dimension.")
    if d == 0:
        raise ValueError("At least one data for plot.")
    if d > 9:
        raise ValueError("""So much data for plot in one figure.
                            Please divide two or more data sets.""")

    fig = plt.figure(figsize=(9, 8))
    subplotposition = ['11', '21', '22', '22', '32', '32', '33', '33', '33']
    axes = []
    cdef int n
    for n in range(d):
        lmn = int(subplotposition[d - 1] + str(n + 1))
        axes.append(fig.add_subplot(lmn))

    for i, ax in enumerate(axes):
        ymin, ymax = min(y_data[i]), max(y_data[i])
        ymargin = (ymax - ymin) * 0.1
        ax.set_ylim(ymin - ymargin, ymax + ymargin)
        ax.plot(x_data[i], y_data[i])
        ax.set_xlabel(x_labels[i], fontsize=16)
        ax.set_ylabel(y_labels[i], fontsize=16)

    fig.subplots_adjust(wspace=0.2, hspace=0.5)
    fig.tight_layout()
    plt.show()
