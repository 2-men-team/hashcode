module project.algo.models.car;

import project.algo.models.ride : Ride;
import project.common.utils : Pos;

/// Car model class
package(project.algo) class Car {
  private Pos _pos; // current position
  private Ride[] _rides; // assigned rides
  private int _step; // current step

  immutable uint id; // unique id

  /// constructor
  this(uint id, Pos pos = Pos(0, 0), int step = 0) {
    this.id = id;
    this._pos = pos;
    this._rides = null;
    this._step = step;
  }

  /// 'pos' field getter and setter
  @property Pos pos() const { return this._pos; }
  @property Pos pos(Pos newPos) { return this._pos = newPos; }

  /// rides getter
  @property Ride[] rides() @safe nothrow
  { return this._rides.dup; }

  /// assign a ride
  Car addRide(Ride ride) {
    this._rides ~= ride;
    return this;
  }

  /// 'step' field getter and setter
  @property int step() const { return this._step; }
  @property int step(int newStep) { return this._step = newStep; }
}
