import tkinter
from tkinter import *
from app.window import Window

# Requirement for running: sudo apt-get install python3-tk
# Run this file at shell as: python3 main.py

if __name__ == "__main__":
    root = Tk() # initializing window
    root.title("Hashcode") # set the title
    window = Window(root) # instantiate window
    window.show() # run program
