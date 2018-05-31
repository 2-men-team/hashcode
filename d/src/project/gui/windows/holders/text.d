module project.gui.windows.holders.text;

/// Implements data holder for the text data

import project.gui.abstractions.interfaces : DataHolder, Attachable;
import dlangui;

/// Contains text data to be sent to some windows
class TextHolder : DataHolder!UIString, Attachable {
  /// Constructor
  this(UIString data) {
    super(data);
  }

  /// Method to attach held data to some text widget
  override Attachable attachTo(Widget widget) {
    widget.text = super._data;
    return this;
  }
}
