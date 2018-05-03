module project.gui.windows.holders.result;

import project.gui.abstractions.interfaces : DataHolder, Attachable;
import project.algo.models.ride : RideResult;
import dlangui;

class ResultHolder : DataHolder!(RideResult[]), Attachable {
  this(in RideResult[] data) {
    super(data);
  }

  override Attachable attachTo(Widget widget) {
    // TODO
    return this;
  }
}
