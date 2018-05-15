module project.gui.windows.handlers.score;

import project.gui.abstractions.interfaces : Attachable;
import project.gui.abstractions : Application;
import project.gui.windows.visualizer : VisualizerParams;
import project.gui.windows.holders : ResultHolder;
import project.algo.simulator : Simulator;

import dlangui;

class VisualizeButtonPressed : OnClickHandler, Attachable {
  override bool onClick(Widget src) {
    VisualizerParams params = VisualizerParams(
      Simulator.instance.height,
      Simulator.instance.width,
      Simulator.instance.result
    );

    Attachable[string] data = [
      "visualizer": new ResultHolder(params)
    ];

    Application.instance.window("visualization").show(data);
    return true;
  }

  override Attachable attachTo(Widget button) pure @safe nothrow {
    button.click = this;
    return this;
  }
}
