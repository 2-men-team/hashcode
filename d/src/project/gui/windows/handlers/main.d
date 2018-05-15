module project.gui.windows.handlers.main;

import project.gui.abstractions.application : Application;
import project.algo : Simulator, SimulatorException;
import project.gui.abstractions.interfaces : Attachable;
import project.gui.windows.holders : TextHolder;

import std.path : sep = dirSeparator;
import std.array : split;
import std.utf : toUTF32, toUTF8;
import std.conv : to;
import std.file : write, FileException;

import dlangui.dialogs.filedlg;
import dlangui.dialogs.dialog;
import dlangui;


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

        src.window.mainWidget.childById("openFileNameWidget").text = infile.toUTF32.split(sep)[$ - 1];
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

class SaveFileButtonPressed : OnClickHandler, Attachable {
  override bool onClick(Widget src) {
    auto dialog = new FileDialog(UIString.fromRaw("Save to file"d), src.window, null, FileDialogFlag.Save);

    dialog.dialogResult = delegate(Dialog dlg, const(Action) action) {
      if (action.id == ACTION_SAVE.id) {
        string outfile = (cast(FileDialog) dlg).filename;

        try {
          string result = Simulator.instance.output;
          if (result is null) {
            src.window.showMessageBox("Error"d, "There is no data to save."d);
            return;
          }

          outfile.write(result);
          src.window.mainWidget.childById("saveFileNameWidget").text = outfile.toUTF32.split(sep)[$ - 1];
        } catch (SimulatorException e) src.window.showMessageBox("Error"d, e.msg.toUTF32);
        catch (FileException e) src.window.showMessageBox("Error"d, e.msg.toUTF32);
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
      Simulator.instance.init(data).exec;
      ulong score = Simulator.instance.score;

      Attachable[string] content = [
        "scoreText": new TextHolder(UIString.fromRaw(score.to!dstring))
      ];

      Application.instance.window("score").show(content);
    } catch (SimulatorException e) src.window.showMessageBox("Error"d, e.msg.toUTF32);

    return true;
  }

  override Attachable attachTo(Widget button) pure @safe nothrow {
    button.click = this;
    return this;
  }
}
