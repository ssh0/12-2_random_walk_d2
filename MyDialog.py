#! /usr/bin/env python
# -*- coding:utf-8 -*-
#
# written by Shotaro Fujimoto, May 2014.

from Tkinter import *


class Dialog():

    def show_window(self, texts, commands):
        """ Show a dialog window.

        texts: A list of text in a dialog
        commands: A list of dictionary {'name of button': command}
        """
        self.root = Tk()
        self.root.title('Dialog')

        frame1 = Frame(self.root, padx=5, pady=5)
        frame1.pack(side='top')
        for text in texts:
            label = Label(frame1, text=text)
            label.pack()

        frame2 = Frame(self.root, padx=5, pady=5)
        frame2.pack(side='bottom')
        self.button = []
        for i, command in enumerate(commands):
            self.button.append(Button(frame2, text=command.items()[0][0],
                                      command=command.items()[0][1]
                                      )
                               )
            self.button[i].grid(row=0, column=i)

        self.root.mainloop()

    def quit(self):
        self.root.destroy()
