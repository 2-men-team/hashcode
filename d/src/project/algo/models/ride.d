module project.algo.models.ride;

public import project.algo.util : Pos;

immutable class Ride {
  uint id;
  uint startStep;
  uint finStep;
  Pos start;
  Pos finish;

  this(uint id, Pos start, Pos finish, uint startStep, uint finStep) immutable pure @nogc @safe nothrow {
    this.id = id;
    this.startStep = startStep;
    this.finStep = finStep;
    this.start = start;
    this.finish = finish;
  }
}

immutable struct RideResult {
  Ride ride;
  bool assigned;
  bool bonused;
  bool scored;

  alias ride this;
}
