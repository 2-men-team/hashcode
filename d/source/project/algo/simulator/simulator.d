module project.algo.simulator.simulator;

/// Implements main algorithm

import std.array : split, array, join;
import std.conv : to, ConvException;
import std.algorithm : map, max, fold;
import std.math : abs;
import std.typecons : Rebindable, rebindable, Tuple;

import project.algo.simulator.exceptions;
import project.algo.models;
import project.common.utils : Singleton, Pos;

import dlangui;

/// validation constants
private enum Validation : uint {
  dataLineLength = 6, // most common input line length
  commonUpperLimit = 10_000, // most common upper limit value
  fleetMaxSize = 1000, // maximum amount of cars
  fleetHeaderIndex = 2, // index of 'fleet' value in header
  maxSteps = 1_000_000_000 // maximum amount of steps
}

/// main algorithm executor
final class Simulator {
  mixin Singleton; // make it Singleton

  private uint _height; // height of the city map
  private uint _width; // width of the city map
  private uint _fleet; // current amount of cars
  private uint _ridesAmount; // current amount of rides
  private uint _bonus; // current bonus value
  private uint _totalSteps; // current amount of steps

  private Ride[uint] _rides; // rides container
  private Car[uint] _cars; // cars container
  private const(RideResult)[] _result; // rides results
  private ulong _score; // score of the algorithm

  /// simulation properties getters
  @property uint height() pure nothrow @nogc @safe { return this._height; }
  @property uint width() pure nothrow @nogc @safe { return this._width; }
  @property uint fleet() pure nothrow @nogc @safe { return this._fleet; }
  @property uint ridesAmount() pure nothrow @nogc @safe { return this._ridesAmount; }
  @property uint bonus() pure nothrow @nogc @safe { return this._bonus; }
  @property uint totalSteps() pure nothrow @nogc @safe { return this._totalSteps; }
  @property bool initialized() pure nothrow @nogc @safe { return this._rides !is null; }

  /// Initialize simulator with the input data
  Simulator initialize(const uint[][] data) @system {
    // check data for validity
    if (!Simulator.validate(data))
      throw new InvalidInputException(UIString.fromRaw("Invalid input data"d));

    // perform initialization
    this._height = data[0][0];
    this._width = data[0][1];
    this._fleet = data[0][2];
    this._ridesAmount = data[0][3];
    this._bonus = data[0][4];
    this._totalSteps = data[0][5];

    this._rides.clear(); // clear previously assigned data

    // produce array of rides
    foreach (uint id, line; data[1 .. $]) {
      RideParams params = {
        start: Pos(line[1], line[0]),
        finish: Pos(line[3], line[2]),
        startStep: line[4],
        finStep: line[5]
      };

      this._rides[id] = new Ride(id, params);
    }

    // produce array of cars
    this._cars.clear();
    foreach (id; 0 .. this._fleet) this._cars[id] = new Car(id);

    // reset previous result
    this._score = 0;
    this._result = null;

    return this;
  }

  /// Initializes simulator with unparsed raw data
  Simulator initialize(string data) @system {
    uint[][] parsed;

    // parse raw data
    try {
      parsed = data.split('\n').map!(line => line.split(' ').map!(to!uint).array).array;
    } catch (ConvException) {
      throw new InvalidInputException(UIString.fromRaw("Invalid input data"d));
    }

    return this.initialize(parsed);
  }

  /// Helper method to calculate "Manhattan distance"
  static uint distance(Pos a, Pos b) pure nothrow @nogc @safe
  { return abs(b.x - a.x) + abs(b.y - a.y); }

  ///Member function to validate the input data
  ///Returns: `true` if data is valid, `false` otherwise
  static bool validate(const uint[][] data) pure nothrow @safe {
    if (data.length == 0) return false;

    const header = data[0]; // header data description

    // validate header
    if (header.length != Validation.dataLineLength)
      return false;

    foreach (i, item; header[0 .. $ - 1]) {
      if (i != Validation.fleetHeaderIndex && !(item >= 1 && item <= Validation.commonUpperLimit))
        return false;
      else if (i == Validation.fleetHeaderIndex && !(item >= 1 && item <= Validation.fleetMaxSize))
        return false;
    }
    if (!(header[$ - 1] >= 1 && header[$ - 1] <= Validation.maxSteps)) return false;

    // validate data
    if (data.length != header[3] + 1) return false;
    foreach (line; data[1 .. $]) {
      if (line.length != Validation.dataLineLength)
        return false;

      // validate ride data
      if (
        !(line[0] < header[0]) ||
        !(line[1] < header[1]) ||
        !(line[2] < header[0]) ||
        !(line[3] < header[1]) ||
        !(line[4] < header[$ - 1]) ||
        !(
          line[5] >= line[4] + Simulator.distance( Pos(line[1], line[0]), Pos(line[3], line[2]) ) &&
          line[5] <= header[$ - 1]
        )
      ) return false;
    }

    return true;
  }

  /// 'result' field getter
  @property const(RideResult)[] result() pure nothrow @safe
  { return this._result.dup; }

  /// 'score' field getter
  @property ulong score() pure nothrow @nogc @safe
  { return this._score; }

  /// method to calculate some info about pair (ride, car)
  private static auto _rideStats(const Ride ride, const Car car) pure nothrow @nogc @safe {
    struct Stats {
      int distToRide; // distance to ride
      int fullLength; // full ride length

      // constructor
      this(const Ride ride, const Car car) {
        this.distToRide = Simulator.distance(car.pos, ride.start);
        this.fullLength = max(this.distToRide, ride.startStep - car.step) + ride.length;
      }
    }

    return Stats(ride, car);
  }

  /// Method to calculate the score of the algorithm
  private void _calcScore(const Ride ride, const Car car) pure nothrow @safe {
    const stats = Simulator._rideStats(ride, car); // some ride statistics
    bool bonused = false; // ride was bonused
    bool scored = false; // ride was scored

    // check for bonus
    if (car.step + stats.distToRide <= ride.startStep) {
      this._score += this._bonus;
      bonused = true;
    }

    // check for car to finish on time
    if (car.step + stats.fullLength <= ride.finStep) {
      this._score += ride.length;
      scored = true;
    }

    // produce ride result
    this._result ~= const RideResult(ride, true, bonused, scored);
  }

  /// main heuristic function
  private long _rank(const Ride ride, const Car car) pure nothrow @nogc @safe {
    const stats = Simulator._rideStats(ride, car); // some ride statistics

    const bonusValid = car.step + stats.distToRide <= ride.startStep; // is bonus valid
    const scoreValid = car.step + stats.fullLength <= ride.finStep; // was finished on time

    return 30 * this._bonus * bonusValid + ride.length * scoreValid - stats.fullLength;
  }

  /// main algorithm execution
  Simulator exec() @system {
    // check for proper initialization
    if (!this.initialized)
      throw new UninitializedException(UIString.fromRaw("Simulator wasn't initialized properly."d));

    // if haven't been executed already
    if (this._result is null) {
      struct RankedRide { // helper struct to hold the ride and its score
        Rebindable!Ride ride;
        long rank = long.min;
        int step;
      }

      // rides that wasn't assigned
      Ride[uint] rides = this._rides.dup;

      foreach (car; this._cars) {
        while (car.step <= this._totalSteps && rides.length != 0) {
          // get the best ride for current car
          RankedRide best = rides.byValue.fold!((acc, ride) {
            const step = car.step + Simulator._rideStats(ride, car).fullLength; // step when ride will be finished
            const rank = this._rank(ride, car); // ride heuristic value

            if (step <= ride.finStep && rank > acc.rank) return RankedRide(ride.rebindable, rank, step);
            return acc;
          })(RankedRide.init);

          // no more good rides left
          if (best == RankedRide.init) break;

          this._calcScore(best.ride, car); // assign ride's score
          car.step = best.step; // change car step
          car.pos = best.ride.finish; // change car position

          car.rides ~= best.ride; // assign a ride
          rides.remove(best.ride.id); // remove this ride from the table
        }
        if (rides.length == 0) break; // no more rides to assign
      }

      // add all the existing rides' results
      foreach (ride; rides) {
        this._result ~= const RideResult(ride, false, false, false);
      }
    }

    return this;
  }

  /// produce string output
  @property string output() @system {
    // check for proper initialization
    if (!this.initialized)
      throw new UninitializedException(UIString.fromRaw("Can't produce output: input data wasn't passed."d));

    // check for executed algorithm
    if (this._result is null) return null;

    // produce output
    return this._cars.byValue.map!(car => (
      (car.rides.length.to!string ~ car.rides.map!(ride => ride.id.to!string).array).join(' ')
    )).join('\n');
  }
}
