module project.main;

import project.app.application : Application, ApplicationInitParams;
import project.app.config : GUI, GUIHandlers;

import dlangui;

// this statement adds standard main function
mixin APP_ENTRY_POINT;

/// Main function (depending on the library)
extern (C) int UIAppMain(string[] args) {
  // application initialization

  // setting up initial parameters for the application
  ApplicationInitParams params = {
    caption: "Course work"d,
    content: GUI,
    handlers: GUIHandlers,
    //icon: "32"
  };

  auto app = new Application(params);

  // application execution
  return app.run;
}
