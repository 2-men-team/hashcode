# importing tkinter and class Window
import tkinter
from tkinter import *
from app.window import Window

# Requirement for running: sudo apt-get install python3-tk
# Run this file at shell as: python3 main.py

if __name__ == "__main__":
    # initializing window
    root = Tk()
    img = PhotoImage(file='./assets/c.ico')
    root.tk.call('wm', 'iconphoto', root._w, img)
    root.title("Hashcode")
    window = Window(root)

    # running program
    root.mainloop()
