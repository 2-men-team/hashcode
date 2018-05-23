module project.gui.windows.visualizer.visualizer;

import project.algo.models.ride : RideResult;
import project.gui.windows.visualizer.path : RidePath;

import std.random : shuffle = partialShuffle;
import std.range : iota;
import std.array : array;

import dlangui;
import dlangui.widgets.metadata;

/// Struct to hold Visualizer params
struct VisualizerParams {
  uint height; // visualization height (from city map)
  uint width; // visualization width (from city map)
  RideResult[] data; // data to visualize
}

/// Ride status colors
private enum StatusColor : uint {
  Taken = 0x008000, // Ride was taken and scored - Green
  NotScored = 0xffa500, // Ride wasn't scored - Orange
  Missed = 0xff0000, // Ride wasn't taken - Red
  Bonused = 0xffff00 // Ride was bonused - Yellow
}

/// Shrink factor to apply to visualization data
private enum int shrinkFactor = 5;

/// Visualizer widget
class Visualizer : CanvasWidget {
  private VisualizerParams _params; // visualization params
  private uint _amount; // amount of rides per time to visualize

  /// Constructor
  this() {
    super();
  }

  /// Initialization method
  Visualizer init(VisualizerParams params, uint amount = 100) {
    this._params = params;
    this._amount = amount;
    return this;
  }

  /// Produces StatusColor of a particular Ride
  private auto _checkStatus(RideResult ride) {
    // struct to hold StatusColor
    struct Status {
      StatusColor point; // color of the start point
      StatusColor path; // color of a whole path
    }

    Status result;

    // calculate color of the Ride
    if (!ride.assigned) result = Status(StatusColor.Missed, StatusColor.Missed);
    else {
      result.path = ride.scored ? StatusColor.Taken : StatusColor.NotScored;
      result.point = ride.bonused ? StatusColor.Bonused : result.path;
    }

    return result;
  }

  /// RidePath struct generator for a particular Ride
  private RidePath _makePath(RideResult ride, Rect rect) {
    RidePath path;
    auto status = this._checkStatus(ride); // get ride status

    // assign ride colors
    path.pathColor = status.path;
    path.pointColor = status.point;

    // calculate start and finish points using widget and simulation sizes
    // apply shrinkFactor to each point
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

  /// Performs visualization
  override void doDraw(DrawBuf buf, Rect rect) {
    // amount of rides to visualize
    ulong amount = this._amount < this._params.data.length ? this._amount : this._params.data.length;

    // perform rundom shuffle and produce visualization
    foreach (i; this._params.data.length.iota.array.shuffle(amount)[0 .. amount]) {
      this._makePath(this._params.data[i], rect).draw(buf); // visualize particular Ride
    }
  }
}

/// Register Visualizer class as a widget to enable its usage in DML
mixin(registerWidgets!("static this", Visualizer));
