module project.gui.abstractions.interfaces;

import project.gui.abstractions.window : WindowTemplate;
import dlangui;

interface Attachable {
  Attachable attachTo(Widget);
}

interface WindowInstantiator {
  Window instantiate(WindowTemplate, Attachable[string]);
}

abstract class DataHolder(T) {
  protected T _data;

  this(T data) {
    this._data = data;
  }
}
