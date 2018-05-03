module project.algo.models.car;

import project.algo.models.ride : Ride;
import project.algo.util : Pos;

class Car {
  private immutable uint _id;
  private Pos _pos;
  private immutable(Ride)[] _rides;
  private uint _step;

  this(uint id, Pos pos = Pos(0, 0), uint step = 0) pure @nogc @safe nothrow {
    this._id = id;
    this._pos = pos;
    this._rides = null;
    this._step = step;
  }

  @property uint id() const pure nothrow @nogc @safe { return this._id; }

  @property Pos pos() const pure nothrow @nogc @safe { return this._pos; }
  @property Pos pos(Pos newPos) pure nothrow @nogc @safe { return this._pos = newPos; }

  @property immutable(Ride)[] rides() const pure @safe nothrow {
    if (this._rides is null) return null;
    return this._rides.idup;
  }

  Car addRide(immutable Ride ride) pure @safe nothrow {
    this._rides ~= ride;
    return this;
  }

  @property uint step() const pure nothrow @nogc @safe { return this._step; }
  @property uint step(uint newStep) pure @nogc @safe nothrow { return this._step = newStep; }
}
