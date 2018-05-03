module project.gui.windows.handlers.score;

import project.gui.abstractions.interfaces : Attachable;
import dlangui;

class VisualizeButtonPressed : OnClickHandler, Attachable {
  override bool onClick(Widget src) {
    // TODO
    return true;
  }

  override Attachable attachTo(Widget button) pure @safe nothrow {
    button.click = this;
    return this;
  }
}
