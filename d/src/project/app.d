module project.app;

import project.gui.abstractions : Application;
import project.gui.windows.content : queue, GUIBuilder;

import dlangui;

// this statement adds standard main function
mixin APP_ENTRY_POINT;

/// Main function (depending on the library)
extern (C) int UIAppMain(string[] args) {
  // application initialization
  Application.instance.theme = "theme_default";
  Application.instance.language = "en";

  // creating windows and adding them to the application
  foreach (window; GUIBuilder!queue.build) {
    Application.instance.addWindow(window);
  }

  // showing main window
  Application.instance.window("main").show(null);

  // application execution
  return Application.instance.exec;
}
