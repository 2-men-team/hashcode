module project.algo.models.car;

/// Implements Car model abstraction

import project.algo.models.ride : Ride;
import project.common.utils : Pos;

/// Car model class
package(project.algo) final class Car {
  Pos pos; // current position
  const(Ride)[] rides; // assigned rides
  int step; // current step

  const uint id; // unique id

  /// constructor
  this(uint id, Pos pos = Pos(0, 0), int step = 0) pure nothrow @nogc @safe {
    this.id = id;
    this.pos = pos;
    this.rides = null;
    this.step = step;
  }
}
