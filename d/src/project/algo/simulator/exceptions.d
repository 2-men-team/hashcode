module project.algo.simulator.exceptions;

/// Implements exceptions thrown by Simulator class

import project.common.exceptions;
import dlangui;

/// Can be throwed by Simulator instance
class SimulatorException : UserException {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

/// Throwed on invalid input passed
class InvalidInputException : SimulatorException {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

/// Throwed when uninitialized Simulator called
class UninitializedException : SimulatorException {
  this(UIString msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}
