module project.algo.models.ride;

import project.algo.simulator : Simulator;
import project.common.utils : Pos;

struct RideParams {
  Pos start;
  Pos finish;
  int startStep;
  int finStep;
}

class Ride {
  immutable uint id;
  private RideParams _params;
  private uint _length;

  this(uint id, RideParams params) pure @nogc @safe nothrow {
    this.id = id;
    this._params = params;
    this._length = Simulator.distance(this._params.start, this._params.finish);
  }

  @property RideParams params() const pure @nogc @safe nothrow
  { return this._params; }

  @property uint length() const pure @nogc @safe nothrow
  { return this._length; }

  alias params this;
}

struct RideResult {
  const Ride ride;
  bool assigned;
  bool bonused;
  bool scored;

  alias ride this;
}
