module project.algo.models.ride;

/// Implements Ride model abstraction

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
package(project.algo) final const class Ride {
  uint id; // unique id
  uint length; // ride length
  RideParams params; // initial params

  /// constructor
  this(uint id, RideParams params) const pure nothrow @nogc @safe {
    this.id = id;
    this.params = params;
    this.length = Simulator.distance(this.params.start, this.params.finish);
  }

  /// make direct access to RideParams fields
  alias params this;
}

/// struct to hold ride's result
const struct RideResult {
  Ride ride;
  bool assigned;
  bool bonused;
  bool scored;

  /// make direct access to ride's properties
  alias ride this;
}
