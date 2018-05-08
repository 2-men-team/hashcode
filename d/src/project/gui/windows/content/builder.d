module project.gui.windows.content.builder;

import project.gui.abstractions.window : WindowTemplate;
import project.gui.abstractions.interfaces : WindowInstantiator;

class GUIBuilder(string[] queue) {
  static WindowTemplate[] build() {
    WindowTemplate[string] gui;

    WindowTemplate window;
    WindowInstantiator instantiator;
    string windowId, parentId;

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

