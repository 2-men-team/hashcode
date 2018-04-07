module project.app.handlers;

import project.simulator : Simulator, SimulatorException, RideResult;

import dlangui.dialogs.filedlg;
import dlangui.dialogs.dialog;

import std.path : sep = dirSeparator;
import std.array : split;
import std.utf : toUTF32, toUTF8;

import dlangui;

interface Attachable {
  Attachable attachTo(Widget);
}

class OpenFileButtonPressed : OnClickHandler, Attachable {
  override bool onClick(Widget src) {
    auto dialog = new FileDialog(UIString.fromRaw("Open data file"d), src.window);

    dialog.dialogResult = delegate(Dialog dlg, const(Action) action) {
      if (action.id == ACTION_OPEN.id) {
        string infile = (cast(FileDialog) dlg).filename;

        if (!src.window.mainWidget.childById!EditBox("inputEditBox").content.load(infile)) {
          src.window.showMessageBox("Error"d, "Error reading input file."d);
          return;
        }

        src.window.mainWidget.childById("fileNameWidget").text = infile.toUTF32.split(sep)[$ - 1];
      }
    };

    dialog.show();

    return true;
  }

  override Attachable attachTo(Widget button) pure @safe nothrow {
    button.click = this;
    return this;
  }
}

class ProceedButtonPressed : OnClickHandler, Attachable {
  override bool onClick(Widget src) {
    string data = src.window.mainWidget.childById("inputEditBox").text.toUTF8;

    if (data.length == 0) {
      src.window.showMessageBox("Error"d, "Input data was not entered."d);
      return true;
    }

    try {
      auto sim = new Simulator(data);
      ulong score = sim.run.score;
      RideResult[] result = sim.result;
      // TODO
    } catch (SimulatorException e) {
      src.window.showMessageBox("Error"d, e.msg.toUTF32);
    }

    return true;
  }

  override Attachable attachTo(Widget button) pure @safe nothrow {
    button.click = this;
    return this;
  }
}
