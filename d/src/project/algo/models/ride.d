module project.algo.models.ride;

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

  this(uint id, RideParams params) pure @nogc @safe nothrow {
    this.id = id;
    this._params = params;
  }

  @property RideParams params() const pure @nogc @safe nothrow
  { return this._params; }

  alias params this;
}

struct RideResult {
  const Ride ride;
  bool assigned;
  bool bonused;
  bool scored;

  alias ride this;
}
