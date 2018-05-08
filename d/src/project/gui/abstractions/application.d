module project.gui.abstractions.application;

import project.common.exceptions : InvalidValueException;
import project.common.utils : Singleton;
import project.gui.abstractions.window;
import dlangui;

class Application {
  private WindowTemplate[string] _windows;

  mixin Singleton;

  @property string theme()
  { return Platform.instance.uiTheme; }

  @property Application theme(string id) {
    Platform.instance.uiTheme = id;
    return this;
  }

  @property string language()
  { return Platform.instance.uiLanguage; }

  @property Application language(string id) {
    Platform.instance.uiLanguage = id;
    return this;
  }

  WindowTemplate window(string id)
  { return this._windows.get(id, null); }

  Application addWindow(WindowTemplate window) {
    if (window is null)
      throw new InvalidValueException("Can't add 'null' value as window.");

    if (window.id in this._windows) this.removeWindow(window.id);
    this._windows[window.id] = window;
    return this;
  }

  WindowTemplate removeWindow(string id) {
    WindowTemplate removed = this._windows.get(id, null);
    if (removed !is null) {
      removed.close();
      removed.parent = null;
      removed.removeChilds();
      this._windows.remove(id);
    }
    return removed;
  }

  int exec()
  { return Platform.instance.enterMessageLoop(); }
}
