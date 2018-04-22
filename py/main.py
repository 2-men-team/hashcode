from tkinter import filedialog
from tkinter import *
import tkinter
from assets.Simulator import Simulator
from assets.Visualizer import Visualizer

# Requirement for running: sudo apt-get install python3-tk
# Run this file at shell as: python3 main.py

class Window(Frame):
    def create_widgets(self):
        # Output
        self.output = tkinter.Button(self, text="Output", command=self.upload_output, width=22, height=1)
        self.output.grid(row=0, column=1, pady=(0,10))

        # uploaded file Text
        self.text_file_output = Entry(self, width=83)
        self.text_file_output.grid(row=0, column=2, pady=(0,5), padx=(5,5))

        # browse Button
        self.input = tkinter.Button(self, text="Input", command=self.upload_input, width=22, height=1)
        self.input.grid(row=1, column=1, pady=(0,10))

        # uploaded file Text
        self.text_file_input = Entry(self, width=83)
        self.text_file_input.grid(row=1, column=2, pady=(0,5), padx=(5,5))

        # text field
        self.text = Text(self, width=125, height=40)
        self.grid(padx=20, pady=20)
        self.text.grid(row=2, column=1, columnspan=2)

        # process button
        self.proceed = tkinter.Button(self)
        self.proceed["text"] = "Process"
        self.proceed["command"] = self.process
        self.proceed["width"] = 30
        self.proceed.grid(row=3, column=1, pady=(14,0), columnspan=2)

    #initializing main frame
    def __init__(self, master=None):
        self.root = master
        self.root.geometry("1024x768")
        self.root.resizable(width=False, height=False)
        self.root.grid_rowconfigure(0, weight=1)
        self.root.grid_columnconfigure(0, weight=1)

        Frame.__init__(self, master)
        self.pack()
        self.create_widgets()

    # uploading input data
    def upload_input(self):
        if(self.text_file_input.get() != ''):
            self.root.filename = self.text_file_input.get()
        else:
            self.root.filename = filedialog.askopenfilename(initialdir = "/home/napoleon/course_work/realization",title = "Select file",filetypes = (("input files","*.in"),("all files","*.*")))
        self.raw = self.read(self.root.filename)
        if self.raw is not None:
            self.text.insert('1.0', self.raw)
            if self.text_file_input.get() == '':
                self.text_file_input.insert(0, self.root.filename)

    # uploadig output file name
    def upload_output(self):
        if(self.text_file_output.get() != ''):
            self.file_out = self.text_file_output.get()
        else:
            self.file_out = filedialog.askopenfilename(initialdir = "/home/napoleon/course_work/realization",title = "Select file",filetypes = (("output files","*.out"),("all files","*.*")))
            self.text_file_output.insert(0, self.file_out)

    # reading input file
    def read(self, input_file):
        try:
            with open(input_file) as file:
                raw = file.read()
            return raw
        except EnvironmentError:
            print("Invalid file name. Please try again")
            return None

    # processing the input file
    def process(self):
        try:
            self.simulator = Simulator(self.raw, self.file_out)
            self.score_dialogue() # show result score
        except AttributeError:
            print("Files missing!")

    # modal window with score result
    def score_dialogue(self):
        dlg = Toplevel()
        dlg.wm_title("Result")
        dlg.geometry("190x80")
        dlg.resizable(width=False, height=False)
        text = "Your score is :  "+ str(self.simulator.score)
        l = Label(dlg, text=text)
        l.grid(row=0, column=0, columnspan=2)

        b = Button(dlg, text="visualize", command=self.visualize, pady=10)
        b.grid(row=1, column=0, columnspan=2)

        dlg.grab_set()
        dlg.wait_window(dlg)

    # visualize modal for showing visualization
    def visualize(self):
        vis = Toplevel()
        vis.wm_title("Visualization")
        vis.geometry("801x601")
        vis.resizable(width=False, height=False)
        generator = Button(vis, text="Generate new!", command=self.generate, pady=10)
        generator.grid(row=1, column=0)
        self.canv = Canvas(vis, width=800, height=600)
        self.canv.grid(row=2,column=0)

        vis.grab_set()
        vis.wait_window(vis)

    # generating image
    def generate(self):
        self.canv.delete("all")
        visualizer = Visualizer(self.canv, self.raw, self.file_out) # Visualize - image generator
        visualizer.visualize()

if __name__ == "__main__":
    root = Tk()
    root.title("Hashcode")
    window = Window(root)
    root.mainloop()
