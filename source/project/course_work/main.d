module project.course_work.main;

import project.course_work.app: Application;

import dlangui;

// this statement adds standard main function
mixin APP_ENTRY_POINT;

/// Main function (depending on the library)
extern (C) int UIAppMain(string[] args) {
  // application initialization
  auto app = new Application(import("gui.dml"));

  // application execution
  return app.buildGUI.run;
}
