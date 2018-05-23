module project.algo.models.ride;

import project.algo.simulator : Simulator;
import project.common.utils : Pos;

/// struct to hold ride's initial params
package(project.algo) struct RideParams {
  Pos start; // start position
  Pos finish; // finish position
  int startStep; // early start step
  int finStep; // latest finish step
}

/// Ride model class
package(project.algo) class Ride {
  immutable uint id; // unique id
  private RideParams _params; // initial params
  private uint _length; // ride length

  /// constructor
  this(uint id, RideParams params) {
    this.id = id;
    this._params = params;
    this._length = Simulator.distance(this._params.start, this._params.finish);
  }

  /// 'params' field getter
  @property RideParams params() const
  { return this._params; }

  /// 'length' field getter
  @property uint length() const
  { return this._length; }

  /// make direct access to RideParams fields
  alias params this;
}

/// struct to hold ride's result
const struct RideResult {
  Ride ride;
  bool assigned;
  bool bonused;
  bool scored;

  // make direct access to ride's properties
  alias ride this;
}
