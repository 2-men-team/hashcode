module project.app.application;

import dlangui;
import project.app.handlers : Attachable;

struct ApplicationInitParams {
  dstring caption; // Window caption
  immutable string content; // Window content
  immutable string[][string] handlers; // Event handlers for window's content
  Window parent = null;
  WindowFlag flag = WindowFlag.Resizable | WindowFlag.MeasureSize;
  uint width = 0u;
  uint height = 0u;
  string theme = "theme_default";
  string lang = "en";
  //string icon = "dlangui_logo1";
}

class Application {
  private Window _window;
  private ApplicationInitParams _params;

  this(ApplicationInitParams params) pure @nogc @safe nothrow {
    this._window = null;
    this._params = params;
  }

  int run() {
    version (WITH_RESOURCES) {
      import project.app.config : resources;
      embeddedResourceList.addResources(embedResourcesFromList!resources());
    }

    Platform.instance.uiTheme = this._params.theme;
    Platform.instance.uiLanguage = this._params.lang;
    //Platform.instance.defaultWindowIcon = this._params.icon;

    this._window = Platform.instance.createWindow(
      this._params.caption,
      this._params.parent,
      this._params.flag,
      this._params.width,
      this._params.height
    );

    this._window.mainWidget = parseML(this._params.content);

    foreach (id, handlers; this._params.handlers) {
      foreach (handler; handlers) {
        (cast(Attachable) Object.factory(handler)).attachTo(this._window.mainWidget.childById(id));
      }
    }

    this._window.show();
    return Platform.instance.enterMessageLoop();
  }
}
