module project.gui.windows.holders.text;

import project.gui.abstractions.interfaces : DataHolder, Attachable;
import dlangui;

class TextHolder : DataHolder!UIString, Attachable {
  this(UIString data) {
    super(data);
  }

  override Attachable attachTo(Widget widget) {
    widget.text = super._data.value;
    return this;
  }
}
