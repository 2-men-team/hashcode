module project.simulator.exceptions;

import std.utf : toUTF8;

import dlangui;

class SimulatorException : Exception {
  this(UIString msg, string file = __FILE__, ulong line = __LINE__) {
    super(msg.value.toUTF8, file, line);
  }
}

class InvalidInputException : SimulatorException {
  this(UIString msg, string file = __FILE__, ulong line = __LINE__) {
    super(msg, file, line);
  }
}

class InvalidAlgorithmException : SimulatorException {
  this(UIString msg, string file = __FILE__, ulong line = __LINE__) {
    super(msg, file, line);
  }
}
