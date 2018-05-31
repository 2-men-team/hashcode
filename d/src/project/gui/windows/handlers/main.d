module project.gui.windows.handlers.main;

/// Implements event handlers for the 'main' window

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

/// Class to handle 'Open file' button click
class OpenFileButtonPressed : OnClickHandler, Attachable {
  /// Handler method
  override bool onClick(Widget src) {
    // dialog to show
    auto dialog = new FileDialog(UIString.fromRaw("Open data file"d), src.window);

    // dialog result handler
    dialog.dialogResult = delegate(Dialog dlg, const(Action) action) {
      if (action.id == ACTION_OPEN.id) {
        string infile = (cast(FileDialog) dlg).filename;

        // try to pass file content to EditBox widget
        if (!src.window.mainWidget.childById!EditBox("inputEditBox").content.load(infile)) {
          src.window.showMessageBox("Error"d, "Error reading input file."d);
          return;
        }

        // change lines with file names
        src.window.mainWidget.childById("openFileNameWidget").text = infile.toUTF32.split(sep)[$ - 1];
        src.window.mainWidget.childById("saveFileNameWidget").text = null;
      }
    };

    dialog.show();
    return true;
  }

  /// Method to connect handler to a specific widget (button in our case)
  override Attachable attachTo(Widget button) {
    button.click = this;
    return this;
  }
}

/// Class to handle 'Save file' button click
class SaveFileButtonPressed : OnClickHandler, Attachable {
  /// Handler mathod
  override bool onClick(Widget src) {
    // dialog to show
    auto dialog = new FileDialog(UIString.fromRaw("Save to file"d), src.window, null, FileDialogFlag.Save);

    // dialog result handler
    dialog.dialogResult = delegate(Dialog dlg, const(Action) action) {
      if (action.id == ACTION_SAVE.id) {
        string outfile = (cast(FileDialog) dlg).filename;

        // try to get algorithm output
        try {
          string result = Simulator.instance.output;
          if (result is null) {
            src.window.showMessageBox("Error"d, "There is no data to save."d);
            return;
          }

          outfile.write(result); // write data to file

          // change file name line
          src.window.mainWidget.childById("saveFileNameWidget").text = outfile.toUTF32.split(sep)[$ - 1];
        }
        // handle different kinds of errors
        catch (SimulatorException e) src.window.showMessageBox("Error"d, e.msg.toUTF32);
        catch (FileException e) src.window.showMessageBox("Error"d, e.msg.toUTF32);
      }
    };

    dialog.show();
    return true;
  }

  /// Method to connect handler to a specific widget (button in our case)
  override Attachable attachTo(Widget button) {
    button.click = this;
    return this;
  }
}

/// Class to handle 'Proceed' button click
class ProceedButtonPressed : OnClickHandler, Attachable {
  override bool onClick(Widget src) {
    // input data
    string data = src.window.mainWidget.childById("inputEditBox").text.toUTF8;

    if (data.length == 0) { // data wasn't entered
      src.window.showMessageBox("Error"d, "Input data was not entered."d);
      return true;
    }

    try { // try execute the main algorithm
      Simulator.instance.init(data).exec;
      ulong score = Simulator.instance.score;

      // data to show on 'score' window
      Attachable[string] content = [
        "scoreText": new TextHolder(UIString.fromRaw(score.to!dstring))
      ];

      Application.instance.window("score").show(content);
    } catch (SimulatorException e) src.window.showMessageBox("Error"d, e.msg.toUTF32);

    return true;
  }

  /// Method to connect handler to a specific widget (button in our case)
  override Attachable attachTo(Widget button) {
    button.click = this;
    return this;
  }
}
