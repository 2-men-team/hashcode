module project.gui.windows.holders.result;

import project.gui.abstractions.interfaces : DataHolder, Attachable;
import project.gui.windows.visualizer : VisualizerParams, Visualizer;
import dlangui;

class ResultHolder : DataHolder!VisualizerParams, Attachable {
  this(VisualizerParams data) {
    super(data);
  }

  override Attachable attachTo(Widget widget) {
    (cast(Visualizer) widget).init(super._data);
    return this;
  }
}
