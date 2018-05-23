module project.gui.windows.handlers.score;

import project.gui.abstractions.interfaces : Attachable;
import project.gui.abstractions : Application;
import project.gui.windows.visualizer : VisualizerParams;
import project.gui.windows.holders : ResultHolder;
import project.algo.simulator : Simulator;

import dlangui;

/// Class to handle 'Visualize' button click
class VisualizeButtonPressed : OnClickHandler, Attachable {
  /// Handler method
  override bool onClick(Widget src) {
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
  override Attachable attachTo(Widget button) {
    button.click = this;
    return this;
  }
}
