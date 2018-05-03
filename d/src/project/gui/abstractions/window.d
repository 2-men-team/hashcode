module project.gui.abstractions.window;

import project.gui.abstractions.interfaces : Attachable, WindowInstantiator;
import project.common.exceptions : InvalidValueException;
import dlangui;

class WindowTemplate {
  private Window _window;
  private WindowTemplate[string] _childs;
  private WindowTemplate _parent;
  private WindowInstantiator _instantiator;

  immutable string id;

  this(string id, WindowInstantiator instantiator) {
    this.id = id;

    if (instantiator is null)
      throw new InvalidValueException("Window instantiator must be specified");

    this._instantiator = instantiator;
  }

//   ~this() {
//     if (this._parent !is null) this.parent = null;
//     foreach (child; this._childs.dup) destroy(child);
//     this.close();
//   }

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

  @property bool instantiated()
  { return this._window !is null; }

  Window dropInstance() {
    Window instance = this._window;
    this._window = null;
    return instance;
  }

  WindowTemplate addChild(WindowTemplate window) {
    if (window is null)
      throw new InvalidValueException("Can't add child window 'null' value.");

    if (window.id in this._childs) this.removeChild(window.id);
    this._childs[window.id] = window;
    return this;
  }

  WindowTemplate removeChild(string id) {
    WindowTemplate removed = this._childs.get(id, null);
    if (removed !is null) {
      removed._parent = null;
      this._childs.remove(id);
    }
    return removed;
  }

  WindowTemplate removeChilds() {
    foreach (id; this._childs.keys) this.removeChild(id);
    return this;
  }

  WindowTemplate child(string id)
  { return this._childs.get(id, null); }

  @property WindowTemplate[] childs()
  { return this._childs.values; }

  void show(Attachable[string] data) {
    this._window = this._instantiator.instantiate(this, data);
    this._window.show();
  }

  void close() {
    foreach (child; this._childs) child.close();
    if (this._window !is null) {
      this._window.close();
      this._window = null;
    }
  }

  alias _window this;
}
