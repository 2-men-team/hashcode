module project.gui.windows.content.builder;

mixin template GUIBuilder(string[] queue) {
  import project.gui.abstractions.window;
  import project.gui.abstractions.interfaces : WindowInstantiator;

  WindowTemplate[] build() {
    WindowTemplate[string] gui;

    WindowTemplate window;
    string windowId, parentId;
    WindowInstantiator instantiator;

    static foreach (item; queue) {
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
