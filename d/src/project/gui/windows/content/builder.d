module project.gui.windows.content.builder;

/// Implements class to generate a gui interface

import project.gui.abstractions.window : WindowTemplate;
import project.gui.abstractions.interfaces : WindowInstantiator;

/// Class to build a GUI following a specific queue
class GUIBuilder(string[] queue) {
  /// main builder method
  static WindowTemplate[] build() {
    WindowTemplate[string] gui;

    WindowTemplate window;
    WindowInstantiator instantiator;
    string windowId, parentId;

    // this will be expanded in compile time
    static foreach (item; queue) {
      mixin("static import " ~ item ~ ";");
      mixin("windowId = " ~ item ~ ".windowId;");
      mixin("parentId = " ~ item ~ ".parentId;");
      mixin("instantiator = " ~ item ~ ".instantiator;");

      window = new WindowTemplate(windowId, instantiator);
      if (parentId !is null) window.parent = gui[parentId];
      gui[windowId] = window;
    }

    return gui.values;
  }
}

