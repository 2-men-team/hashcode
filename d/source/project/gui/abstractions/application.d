module project.gui.abstractions.application;

/// Implements Application abstraction

import project.common.exceptions : InvalidValueException;
import project.common.utils : Singleton;
import project.gui.abstractions.window;
import dlangui;

/// Application abstraction class
final class Application {
  mixin Singleton; // make it Singleton

  private WindowTemplate[string] _windows; // saved windows

  /// 'theme' property getter and setter
  @property string theme()
  { return Platform.instance.uiTheme; }

  @property Application theme(string id) {
    Platform.instance.uiTheme = id;
    return this;
  }

  /// 'language' property getter and setter
  @property string language()
  { return Platform.instance.uiLanguage; }

  @property Application language(string id) {
    Platform.instance.uiLanguage = id;
    return this;
  }

  /// get saved window by id
  WindowTemplate window(string id) pure nothrow @safe
  { return id in this._windows ? this._windows[id] : null; }

  /// add window to the application
  Application addWindow(WindowTemplate window) @system {
    if (window is null)
      throw new InvalidValueException("Can't add 'null' value as window.");

    if (window.id in this._windows) this.removeWindow(window.id); // if window already exists
    this._windows[window.id] = window;
    return this;
  }

  /// remove window from application by id
  WindowTemplate removeWindow(string id) @system {
    WindowTemplate removed = this._windows.get(id, null);
    if (removed !is null) { // window with id exists
      removed.close();
      removed.parent = null;
      removed.removeChilds();
      this._windows.remove(id);
    }
    return removed;
  }

  /// Application executor
  int exec()
  { return Platform.instance.enterMessageLoop(); }
}
