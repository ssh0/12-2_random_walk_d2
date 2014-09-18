#! /usr/bin/env python
# -*- coding:utf-8 -*-
#
# written by Shotaro Fujimoto, June 2014.

from random_walk_d2 import *
from MyDialog import Dialog
import sys

if __name__ == '__main__':

    import time
    N = range(1, 501)  # caluculate when N = *
    nwalkers = 500  # number of random walkers

    def show_figure():
        sttime = time.time()
        random_walk_d2(N, nwalkers)
        entime = time.time()
        print entime - sttime
        draw_figure(nwalkers)

    def graph():
        sttime = time.time()
        random_walk_d2(N, nwalkers)
        entime = time.time()
        print entime - sttime
        x_labels = [r'$N$'] * 5
        y_labels = [r'$<x(N)>$', r'$<y(N)>$', r'$<\Delta x^{2}(N)>$',
                    r'$<\Delta y^{2}(N)>$', r'$<\Delta R^{2}(N)>$']
        plot_graph([N] * 5, calc(nwalkers), x_labels, y_labels)

    window = Dialog()
    window.show_window(["Simulation of random walk in two-dimentional space.",
                        "Press the button to start the simulation."],
                       [{'figure': show_figure}, {
                           'graph': graph}, {'Quit': sys.exit}]
                       )
