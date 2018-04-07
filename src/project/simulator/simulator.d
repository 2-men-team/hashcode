module project.simulator.simulator;

import std.array : split, array;
import std.conv : to, ConvException;
import std.algorithm.iteration : map;
import std.math : abs;

import project.simulator.exceptions : InvalidInputException, InvalidAlgorithmException;
import project.simulator.car : Car;
import project.simulator.ride : Ride;
public import project.simulator.ride : RideResult;
public import project.simulator.util : Pos;

import dlangui;

private enum Validation : uint {
  contentDescriptionLength = 6,
  commonUpperLimit = 10_000,
  fleetMaxSize = 1000,
  fleetHeaderIndex = 2,
  maxSteps = 1_000_000_000
}

class Simulator {
  immutable uint height;
  immutable uint width;
  immutable uint fleet;
  immutable uint rides;
  immutable uint bonus;
  immutable uint totalSteps;

  private immutable(Ride)[] _rides;
  private Car[] _cars;
  private immutable(RideResult)[] _result;
  private ulong _score;

  this(in uint[][] data) {
    if (!Simulator.validate(data))
      throw new InvalidInputException(UIString.fromRaw("Invalid input data"d));

    this.height = data[0][0];
    this.width = data[0][1];
    this.fleet = data[0][2];
    this.rides = data[0][3];
    this.bonus = data[0][4];
    this.totalSteps = data[0][5];

    foreach (uint id, line; data[1 .. $]) {
      this._rides ~= new immutable Ride(
        id,
        Pos(line[1], line[0]),
        Pos(line[3], line[2]),
        line[4],
        line[5]
      );
    }

    foreach (id; 0 .. this.fleet) {
      this._cars ~= new Car(id);
    }

    this._result = null;
    this._score = 0;
  }

  this(string data) {
    uint[][] parsed;

    try {
      parsed = data.split('\n').map!(line => line.split(' ').map!(to!uint).array).array;
    } catch (ConvException) {
      throw new InvalidInputException(UIString.fromRaw("Invalid input data"d));
    }

    this(parsed);
  }

  private static uint _distance(Pos a, Pos b) pure @safe @nogc nothrow {
    return abs(b.x - a.x) + abs(b.y - a.y);
  }

  static bool validate(in uint[][] data) pure @safe @nogc nothrow {
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
          line[5] >= line[4] + Simulator._distance( Pos(line[1], line[0]), Pos(line[3], line[2]) ) &&
          line[5] <= header[$ - 1]
        )
      ) {
        return false;
      }
    }

    return true;
  }

  @property immutable(RideResult)[] result() const pure @safe nothrow {
    if (this._result is null) return null;
    return this._result.idup;
  }

  @property ulong score() {
    if (this._result !is null) return this._score;
    // TODO
    return this._score;
  }

  Simulator run() {
    // TODO
    return this;
  }
}
