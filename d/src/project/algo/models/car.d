module project.algo.models.car;

import project.algo.models.ride : Ride;
import project.common.utils : Pos;

class Car {
  private Pos _pos;
  private Ride[] _rides;
  private int _step;

  immutable uint id;

  this(uint id, Pos pos = Pos(0, 0), int step = 0) pure @nogc @safe nothrow {
    this.id = id;
    this._pos = pos;
    this._rides = null;
    this._step = step;
  }

  @property Pos pos() const pure nothrow @nogc @safe { return this._pos; }
  @property Pos pos(Pos newPos) pure nothrow @nogc @safe { return this._pos = newPos; }

  @property Ride[] rides() @safe nothrow
  { return this._rides.dup; }

  Car addRide(Ride ride) pure @safe nothrow {
    this._rides ~= ride;
    return this;
  }

  @property int step() const pure nothrow @nogc @safe { return this._step; }
  @property int step(int newStep) pure @nogc @safe nothrow { return this._step = newStep; }
}
