module project.common.utils;

/// Implements some useful utilities

/// Singleton pattern implementation
mixin template Singleton() {
  private static typeof(this) _instance;
  private this() pure nothrow @nogc @safe { }

  static @property typeof(this) instance() nothrow @safe {
    if (typeof(this)._instance is null)
      typeof(this)._instance = new typeof(this);
    return typeof(this)._instance;
  }
}

/// Position holder struct
struct Pos {
  int x;
  int y;
}

/// Class to build a GUI following a specific order
struct GUIBuilder(string[] order) {
  import project.gui.abstractions.window : WindowTemplate;
  import project.gui.abstractions.interfaces : WindowInstantiator;

  /// constructor
  @disable this(); // do not instantiate

  /// main builder method
  static WindowTemplate[] build() @system {
    WindowTemplate[string] gui;

    // this will be expanded in compile time
    static foreach (item; order) {{
      mixin("import " ~ item ~ " : windowId, parentId, instantiator;");

      WindowTemplate window = new WindowTemplate(windowId, instantiator);
      if (parentId !is null) window.parent = gui[parentId];
      gui[windowId] = window;
    }}

    return gui.values;
  }
}
