module project.gui.windows.instantiator.instantiator;

import project.gui.abstractions.window;
import project.gui.abstractions.interfaces : Attachable, WindowInstantiator;
import project.common.exceptions : InvalidValueException;
import project.gui.windows.instantiator.exceptions;
import dlangui;

struct WindowInitParams {
  UIString caption; // Window caption
  string content; // Window content
  string[][string] handlers; // Event handlers for window's content
  WindowFlag flags = WindowFlag.Resizable | WindowFlag.MeasureSize;
  uint width = 0u;
  uint height = 0u;
}

class BasicWindowInstantiator : WindowInstantiator {
  private WindowInitParams _params;

  this(WindowInitParams params) {
    this._params = params;
  }

  private Window _createWindow(WindowTemplate caller) {
    Window window = Platform.instance.createWindow(
      this._params.caption,
      null,
      this._params.flags,
      this._params.width,
      this._params.height
    );

    if (window is null)
      throw new InstantiationException("Error while instantiating a window.");

//     window.onClose = delegate() {
//       //foreach (child; caller.childs) child.close();
//       //caller.dropInstance();
//       caller.close();
//     };

    window.mainWidget = parseML(this._params.content);

    foreach (id, handlers; this._params.handlers) {
      Widget widget = window.mainWidget.childById(id);
      if (widget is null)
        throw new InvalidValueException("Unknown widget with id '" ~ id ~ "'.");

      foreach (handler; handlers) {
        (cast(Attachable) Object.factory(handler)).attachTo(widget);
      }
    }

    return window;
  }

  private void _fillContent(Window target, Attachable[string] content) {
    foreach (id, item; content) {
      Widget widget = target.mainWidget.childById(id);
      if (widget is null)
        throw new InvalidValueException("Unknown widget with id '" ~ id ~ "'.");

      item.attachTo(widget);
    }
  }

  override Window instantiate(WindowTemplate caller, Attachable[string] data) {
    Window instance = this._createWindow(caller);
    this._fillContent(instance, data);
    return instance;
  }
}
