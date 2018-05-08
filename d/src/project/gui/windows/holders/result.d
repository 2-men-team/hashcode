module project.gui.windows.holders.result;

import project.gui.abstractions.interfaces : DataHolder, Attachable;
import project.algo.models.ride : RideResult;
import dlangui;

class ResultHolder : DataHolder!(const RideResult[]), Attachable {
  this(const RideResult[] data) {
    super(data);
  }

  override Attachable attachTo(Widget widget) {
    // TODO
    return this;
  }
}
