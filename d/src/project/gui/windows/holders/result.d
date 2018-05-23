module project.gui.windows.holders.result;

import project.gui.abstractions.interfaces : DataHolder, Attachable;
import project.gui.windows.visualizer : VisualizerParams, Visualizer;
import dlangui;

/// Contains VisualizerParams data to be sent to some windows
class ResultHolder : DataHolder!VisualizerParams, Attachable {
  /// Constructor
  this(VisualizerParams data) {
    super(data);
  }

  /// Method to attach held data to Visualizer widget
  override Attachable attachTo(Widget widget) {
    (cast(Visualizer) widget).init(super._data);
    return this;
  }
}
