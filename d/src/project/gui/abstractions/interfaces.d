module project.gui.abstractions.interfaces;

import project.gui.abstractions.window : WindowTemplate;
import dlangui;

/// Provides unified interface to perform
/// communication between different kinds of objects
interface Attachable {
  Attachable attachTo(Widget);
}

/// Provides interface to perform proper window instantiation
interface WindowInstantiator {
  Window instantiate(WindowTemplate, Attachable[string]);
  void fillContent(Window, Attachable[string]);
}

/// Provides an abstraction to contain different types of value
abstract class DataHolder(T) {
  protected T _data;

  this(T data) {
    this._data = data;
  }
}
