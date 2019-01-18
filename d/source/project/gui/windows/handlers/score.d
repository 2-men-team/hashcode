module project.gui.windows.handlers.score;

/// Implements event handlers for the 'score' window

import project.gui.abstractions.interfaces : Attachable;
import project.gui.abstractions : Application;
import project.gui.windows.visualizer : VisualizerParams;
import project.gui.windows.holders : ResultHolder;
import project.algo.simulator : Simulator;
import project.common.exceptions : InvalidValueException;

import dlangui;

/// Class to handle 'Visualize' button click
final class VisualizeButtonPressed : OnClickHandler, Attachable {
  /// Handler method
  override bool onClick(Widget src) @system {
    // visualization params
    VisualizerParams params = VisualizerParams(
      Simulator.instance.height,
      Simulator.instance.width,
      Simulator.instance.result
    );

    // data, passed to Visualizer
    Attachable[string] data = [
      "visualizer": new ResultHolder(params)
    ];

    Application.instance.window("visualization").show(data);
    return true;
  }

  /// Method to connect handler to a specific widget (button in our case)
  override Attachable attachTo(Widget widget) pure @safe {
    if (auto button = cast(Button) widget) button.click = this;
    else
      throw new InvalidValueException("Can't cast 'widget' argument to Button.");
    return this;
  }
}
