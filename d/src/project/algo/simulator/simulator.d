module project.algo.simulator.simulator;

import std.array : split, array, join;
import std.conv : to, ConvException;
import std.algorithm : map, max = maxElement;
import std.math : abs;

import project.algo.simulator.exceptions;
import project.algo.models;
import project.common.utils;

import dlangui;

private enum Validation : uint {
  contentDescriptionLength = 6,
  commonUpperLimit = 10_000,
  fleetMaxSize = 1000,
  fleetHeaderIndex = 2,
  maxSteps = 1_000_000_000
}

class Simulator {
  private uint _height;
  private uint _width;
  private uint _fleet;
  private uint _ridesAmount;
  private uint _bonus;
  private uint _totalSteps;

  private Ride[uint] _rides;
  private Car[uint] _cars;
  private RideResult[] _result;
  private ulong _score;

  mixin Singleton;

  @property uint height() { return this._height; }
  @property uint width() { return this._width; }
  @property uint fleet() { return this._fleet; }
  @property uint ridesAmount() { return this._ridesAmount; }
  @property uint bonus() { return this._bonus; }
  @property uint totalSteps() { return this._totalSteps; }
  @property bool initialized() { return this._rides !is null; }

  /// Initialize simulator with the input data
  Simulator init(const uint[][] data) {
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
    foreach (id; 0 .. this._fleet) {
      this._cars[id] = new Car(id);
    }

    this._score = 0;
    this._result = null;

    return this;
  }

  /// Initializes simulator with unparsed raw data
  Simulator init(string data) {
    uint[][] parsed;

    try {
      parsed = data.split('\n').map!(line => line.split(' ').map!(to!uint).array).array;
    } catch (ConvException) {
      throw new InvalidInputException(UIString.fromRaw("Invalid input data"d));
    }

    return this.init(parsed);
  }

  /// Helper method to calculate "Manhattan distance"
  static uint distance(Pos a, Pos b) pure @safe @nogc nothrow
  { return abs(b.x - a.x) + abs(b.y - a.y); }

  /**
  * Member function to validate the input data
  * Returns: `true` if data is valid, `false` otherwise
  */
  static bool validate(const uint[][] data) {
    if (data.length == 0) return false;

    const uint[] header = data[0];

    if (header.length != Validation.contentDescriptionLength)
      return false;

    foreach (i, item; header[0 .. $ - 1]) {
      if (i != Validation.fleetHeaderIndex && !(item >= 1 && item <= Validation.commonUpperLimit))
        return false;
      else if (i == Validation.fleetHeaderIndex && !(item >= 1 && item <= Validation.fleetMaxSize))
        return false;
    }
    if (!(header[$ - 1] >= 1 && header[$ - 1] <= Validation.maxSteps)) return false;

    if (data.length != header[3] + 1) return false;
    foreach (line; data[1 .. $]) {
      if (line.length != Validation.contentDescriptionLength)
        return false;

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

  @property RideResult[] result() const @safe nothrow
  { return this._result.dup; }

  @property ulong score() const pure @safe nothrow @nogc
  { return this._score; }

  /// Method to calculate the score of the algorithm
  private void _calcScore() {
    Ride[uint] rides = this._rides.dup; // make a copy of the rides

    foreach (car; this._cars) {
      uint step = 0; // current car step
      Pos pos = Pos(0, 0); // current car position

      foreach (ride; car.rides) {
        if (ride.id !in rides) // was already assigned to another car
          throw new InvalidAlgorithmException("One ride is taken multiple times.");

        long distToRide = Simulator.distance(pos, ride.start);
        bool isBonused = false;
        bool isScored = false;

        if (step + distToRide <= this._totalSteps) { // car can start the ride
          step += distToRide;
          if (step <= ride.startStep) { // can start on time
            this._score += this._bonus;
            step = ride.startStep;
            isBonused = true;
          }

          step += ride.length;
          if (step <= ride.finStep) { // car can finish this ride
            this._score += ride.length;
            isScored = true;
          }
        } else step += distToRide + ride.length; // if ride can't be finished, just add full ride length to car step
        pos = ride.finish; // change car position

        // if ride can't be finished by the end of the simulation,
        // conditions above won't be done on the next iteration

        this._result ~= RideResult(ride, true, isBonused, isScored); // add summary of the ride to the result array
        rides.remove(ride.id); // mark ride as taken
      }
    }

    // add all unassigned rides to the result array
    foreach (ride; rides) {
      this._result ~= RideResult(ride, false, false, false);
    }
  }

  private long _rank(const Ride ride, const Car car, long maxStep) @safe pure @nogc nothrow {
    long distToRide = Simulator.distance(car.pos, ride.start);
    long fullLength = distToRide + ride.length;

    bool bonusValid = car.step + distToRide <= ride.startStep;
    bool scoreValid = car.step + fullLength <= ride.finStep;

    long k;
    if (maxStep <= ride.startStep) k = maxStep - ride.finStep;
    else if (car.step < ride.startStep) {
      if (maxStep < ride.finStep) k = maxStep - ride.startStep + maxStep - ride.finStep;
      else k = maxStep - ride.startStep;
    } else k = -fullLength;

    return (this._bonus * bonusValid) ^^ 2 + ride.length * scoreValid + k;
    //return (ride.length + this._bonus) ^^ 2 - (distToRide * abs(ride.startStep - car.step - distToRide)) + k;
  }

  private auto _maxPair(Ride[uint] rides, Car[uint] cars, long maxStep) @safe pure @nogc nothrow {
    struct Pair {
      Ride ride;
      Car car;
    }

    Pair result;
    long maxRank = long.min;

    foreach (ride; rides.byValue) {
      foreach (car; cars.byValue) {
        long rank = this._rank(ride, car, maxStep);

        if (rank > maxRank) {
          maxRank = rank;
          result = Pair(ride, car);
        }
      }
    }

    return result;
  }

  Simulator exec() {
    if (!this.initialized)
      throw new UninitializedException(UIString.fromRaw("Simulator wasn't initialized properly."d));

    Ride[uint] rides = this._rides.dup;
    Car[uint] cars = this._cars.dup;
    uint maxStep = 0;

    while (rides.length != 0 && cars.length != 0) {
      auto pair = this._maxPair(rides, cars, maxStep);

      with (pair) {
        car.addRide(ride);
        car.step = car.step + Simulator.distance(car.pos, ride.start) + ride.length;

        if (car.step >= this._totalSteps) {
          cars.remove(car.id);
          if (cars.length) maxStep = cars.byValue.max!(item => item.step).step;
        } else if (car.step > maxStep) maxStep = car.step;

        car.pos = ride.finish;
        rides.remove(ride.id);
      }
    }

    this._calcScore();
    return this;
  }

  @property string output() {
    if (!this.initialized)
      throw new UninitializedException(UIString.fromRaw("Can't produce output: input data wasn't passed."d));

    if (this._result is null) return null;

    return this._cars.byValue.map!(car => (
      (car.rides.length.to!string ~ car.rides.map!(ride => ride.id.to!string).array).join(' ')
    )).join('\n');
  }
}
