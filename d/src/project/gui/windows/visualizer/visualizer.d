module project.gui.windows.visualizer.visualizer;

import project.algo.models.ride : RideResult;
import project.gui.windows.visualizer.path : RidePath;

import std.random : shuffle = partialShuffle;
import std.range : iota;
import std.array : array;

import dlangui;
import dlangui.widgets.metadata;

struct VisualizerParams {
  uint height;
  uint width;
  RideResult[] data;
}

private enum StatusColor : uint {
  Taken = 0x008000,
  NotScored = 0xffa500,
  Missed = 0xff0000,
  Bonused = 0xffff00
}

private enum int shrinkFactor = 10;

class Visualizer : CanvasWidget {
  private VisualizerParams _params;
  private uint _amount;

  this() {
    super();
  }

  Visualizer init(VisualizerParams params, uint amount = 100) {
    this._params = params;
    this._amount = amount;
    return this;
  }

  private auto _checkStatus(RideResult ride) {
    struct Status {
      StatusColor point;
      StatusColor path;
    }

    Status result;

    if (!ride.assigned) result = Status(StatusColor.Missed, StatusColor.Missed);
    else {
      result.path = ride.scored ? StatusColor.Taken : StatusColor.NotScored;
      result.point = ride.bonused ? StatusColor.Bonused : result.path;
    }

    return result;
  }

  private RidePath _makePath(RideResult ride, Rect rect) {
    RidePath path;
    auto status = this._checkStatus(ride);

    path.pathColor = status.path;
    path.pointColor = status.point;

    path.from = Point(
      rect.left + ride.start.x * (super.width - shrinkFactor) / this._params.width,
      rect.top + ride.start.y * (super.height - shrinkFactor) / this._params.height
    );

    path.to = Point(
      rect.left + ride.finish.x * (super.width - shrinkFactor) / this._params.width,
      rect.top + ride.finish.y * (super.height - shrinkFactor) / this._params.height
    );

    return path;
  }

  override void doDraw(DrawBuf buf, Rect rect) {
    ulong amount = this._amount < this._params.data.length ? this._amount : this._params.data.length;

    ulong[] ids = this._params.data.length.iota.array;
    ids.shuffle(amount);
    foreach (i; ids[0 .. amount]) {
      this._makePath(this._params.data[i], rect).draw(buf);
    }
  }
}

mixin(registerWidgets!("static this", Visualizer));
