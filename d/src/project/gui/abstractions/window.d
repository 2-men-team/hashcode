module project.gui.abstractions.window;

/// Implements WindowTemplate abstraction

import project.gui.abstractions.interfaces : Attachable, WindowInstantiator;
import project.common.exceptions : InvalidValueException;
import dlangui;

/// Window template abstraction class
class WindowTemplate {
  private Window _window; // Window class instance
  private WindowTemplate[string] _childs; // 'child' windows
  private WindowTemplate _parent; // 'parent' window
  private WindowInstantiator _instantiator; // used to instantiate Window object

  immutable string id; // window unique id

  /// constructor
  this(string id, WindowInstantiator instantiator) {
    this.id = id;

    if (instantiator is null)
      throw new InvalidValueException("Window instantiator must be specified");

    this._instantiator = instantiator;
  }

  /// 'parent' property getter and setter
  @property WindowTemplate parent()
  { return this._parent; }

  @property WindowTemplate parent(WindowTemplate parent) {
    if (parent !is this._parent) {
      if (this._parent !is null) this._parent.removeChild(this.id);
      if (parent !is null) parent.addChild(this);
      this._parent = parent;
    }
    return this;
  }

  /// check for instance availability
  bool instantiated()
  { return this._window !is null; }

  /// 'instance' property getter
  @property Window instance()
  { return this._window; }

  /// add window as a child
  WindowTemplate addChild(WindowTemplate window) {
    if (window is null)
      throw new InvalidValueException("Can't add child window 'null' value.");

    if (window.id in this._childs) this.removeChild(window.id); // if child was already assigned
    this._childs[window.id] = window;
    return this;
  }

  /// remove child by its id
  WindowTemplate removeChild(string id) {
    WindowTemplate removed = this._childs.get(id, null);
    if (removed !is null) { // if present
      removed._parent = null;
      this._childs.remove(id);
    }
    return removed;
  }

  /// clear all childs
  WindowTemplate removeChilds() {
    foreach (id; this._childs.byKey) this.removeChild(id);
    return this;
  }

  /// get child by its id
  WindowTemplate child(string id)
  { return this._childs.get(id, null); }

  /// get list of all childs
  @property WindowTemplate[] childs()
  { return this._childs.values; }

  /// show window on screen with specified 'data'
  void show(Attachable[string] data) {
    if (this.instantiated) { // window instance was already created and showed
      this._instantiator.fillContent(this._window, data); // change its inner content
      this._window.update(true); // update it
    } else {
      this._window = this._instantiator.instantiate(this, data); // instantiate Window object
      this._window.show(); // show it on screen
    }
  }

  /// closes window using native methods (optionally)
  void close(bool native = true) {
    if (this.instantiated) { // was already instantiated and showed
      foreach (child; this._childs) child.close();
      if (native) this._window.close();
      this._window = null;
    }
  }

  /// make direct access to instance's methods and fields
  alias instance this;
}
