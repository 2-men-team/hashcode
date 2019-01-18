module project.gui.windows.holders.result;

/// Implements data holder for the result of the algorithm

import project.gui.abstractions.interfaces : DataHolder, Attachable;
import project.gui.windows.visualizer : VisualizerParams, Visualizer;
import project.common.exceptions : InvalidValueException;
import dlangui;

/// Contains VisualizerParams data to be sent to some windows
final class ResultHolder : DataHolder!VisualizerParams, Attachable {
  /// Constructor
  this(VisualizerParams data) pure nothrow @nogc @safe { super(data); }

  /// Method to attach held data to Visualizer widget
  override Attachable attachTo(Widget widget) pure @safe {
    if (auto visualizer = cast(Visualizer) widget)
      visualizer.initialize(super._data);
    else
      throw new InvalidValueException("Can't cast 'widget' argument to Visualizer.");
    return this;
  }
}
