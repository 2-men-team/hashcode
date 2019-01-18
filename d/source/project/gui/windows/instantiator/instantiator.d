module project.gui.windows.instantiator.instantiator;

/// Implements window instantiator class

import project.gui.abstractions.window;
import project.gui.abstractions.interfaces : Attachable, WindowInstantiator;
import project.common.exceptions : InvalidValueException;
import project.gui.windows.instantiator.exceptions;
import dlangui;

/// Struct to contain initial params for Window object
const struct WindowInitParams {
  UIString caption; // Window caption
  string content; // Window content in DML
  string[][string] handlers; // Event handlers for window content
  WindowFlag flags = WindowFlag.Resizable | WindowFlag.MeasureSize; // Window flags
  uint width = 0u; // Window width
  uint height = 0u; // Window height
}

/// Main class to initialize windows in this project
final const class BasicWindowInstantiator : WindowInstantiator {
  private WindowInitParams _params; // specified Window params

  /// Constructor
  this(const WindowInitParams params) const pure nothrow @nogc @safe {
    this._params = params;
  }

  /// Creates Window class instance
  private Window _createWindow(WindowTemplate caller) const {
    // perform Window creation
    Window window = Platform.instance.createWindow(
      this._params.caption,
      null,
      this._params.flags,
      this._params.width,
      this._params.height
    );

    if (window is null) // unsuccessful window creation
      throw new InstantiationException("Error while instantiating a window.");

    // on close handler to ensure proper window destruction
    window.onClose = delegate() {
      caller.close(false);
    };

    window.mainWidget = parseML(this._params.content); // add window content

    // attach window handlers to specified widgets
    foreach (id, handlers; this._params.handlers) {
      Widget widget = window.mainWidget.childById(id); // widget to assign to
      if (widget is null) // widget doesn't exist
        throw new InvalidValueException("Unknown widget with id '" ~ id ~ "'.");

      // perform attachment
      foreach (handler; handlers) {
        (cast(Attachable) Object.factory(handler)).attachTo(widget);
      }
    }

    return window;
  }

  /// Fills content of Window object
  override void fillContent(Window target, Attachable[string] content) const {
    if (target is null)
      throw new InvalidValueException("Can't fill content of 'null'.");

    // attach pieces of data to the corresponding widget
    foreach (id, item; content) {
      Widget widget = target.mainWidget.childById(id); // widget to fill in
      if (widget is null) // widget doesn't exist
        throw new InvalidValueException("Unknown widget with id '" ~ id ~ "'.");

      item.attachTo(widget); // attach data to widget
    }
  }

  /// Instantiates Window object and fills its content
  override Window instantiate(WindowTemplate caller, Attachable[string] data) const {
    Window instance = this._createWindow(caller);
    this.fillContent(instance, data);
    return instance;
  }
}
